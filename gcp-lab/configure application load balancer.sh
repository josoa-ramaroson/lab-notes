#!/bin/bash
echo "Task 1. Set the default region and zone for all resources"
gcloud config set compute/region us-east1
gcloud config set compute/zone us-east1-d

echo "Task 2. Create multiple web server instances"
echo "First web server"
gcloud compute instances create www1 \
--zone=us-east1-d \
--tags=network-lb-tag \
--machine-type=e2-small \
--image-family=debian-11 \
--image-project=debian-cloud \
--metadata=startup-script='#!/bin/bash
    apt-get update
    apt-get install apache2 -y
    service apache2 restart
    echo "
<h3>Web Server: www1</h3>" | tee /var/www/html/index.html'

echo "Second server"
gcloud compute instances create www2 \
--zone=us-east1-d \
--tags=network-lb-tag \
--machine-type=e2-small \
--image-family=debian-11 \
--image-project=debian-cloud \
--metadata=startup-script='#!/bin/bash
apt-get update
apt-get install apache2 -y
service apache2 restart
echo "<h3>Web Server: www2</h3>" | tee /var/www/html/index.html'

echo "Third server"
gcloud compute instances create www3 \
--zone=us-east1-d  \
--tags=network-lb-tag \
--machine-type=e2-small \
--image-family=debian-11 \
--image-project=debian-cloud \
--metadata=startup-script='#!/bin/bash
    apt-get update
    apt-get install apache2 -y
    service apache2 restart
    echo "
<h3>Web Server: www3</h3>" | tee /var/www/html/index.html'

echo "Creating firewall rules"
gcloud compute firewall-rules create www-firewall-network-lb --target-tags network-lb-tag --allow tcp:80

echo "listing the instance to get their external IP"
gcloud compute instances list


echo "Task 3. Create an Application Load Balancer"
echo "creating instance template..."
gcloud compute instance-templates create lb-backend-template \
--region=us-east1 \
--network=default \
--subnet=default \
--tags=allow-health-check \
--machine-type=e2-medium \
--image-family=debian-11 \
--image-project=debian-cloud \
--metadata=startup-script='#!/bin/bash
apt-get update
apt-get install apache2 -y
a2ensite default-ssl
a2enmod ssl
vm_hostname="$(curl -H "Metadata-Flavor:Google" http://169.254.169.254/computeMetadata/v1/instance/name)"
echo "Page served from: $vm_hostname" | tee /var/www/html/index.html
systemctl restart apache2'

echo "Creating a managed instance group based on the template..."
gcloud compute instance-groups managed create lb-backend-group --template=lb-backend-template --size=2 --zone=us-east1-d

echo "Creating the firewall rule to allow health check traffic to the backend group..."
gcloud compute firewall-rules create fw-allow-health-check \
--network=default \
--action=allow \
--direction=ingress \
--source-ranges=130.211.0.0/22,35.191.0.0/16 \
--target-tags=allow-health-check \
--rules=tcp:80

echo "Setting a global static external IP address"
gcloud compute addresses create lb-ipv4-1 --ip-version=IPV4 --global

echo "take note of the IPv4 that was reserved"
LB_ADDRESS=$(gcloud compute addresses describe lb-ipv4-1 --format="get(address)" --global)

echo "creating a health check for the load balancer"
gcloud compute health-checks create http http-basic-check --port 80

echo "create the backend service"
gcloud compute backend-services create web-backend-service \
--protocol=HTTP \
--port-name=http \
--health-checks=http-basic-check \
--global 

echo "Add the instance group as the backend to the backend service"
gcloud compute backend-services add-backend web-backend-service \
--instance-group=lb-backend-group \
--instance-group-zone=us-east1-d \
--global

echo "Creating a URL map to route the incoming requests to the default backend service"
gcloud compute url-maps create web-map-http \
--default-service web-backend-service

echo "Creating a target HTTP proxy to route requests to the URL map"
gcloud compute target-http-proxies create http-lb-proxy --url-map web-map-http

echo "Creating the global forwarding rule to route incoming requests to the proxy"
gcloud compute forwarding-rules create http-content-rule \
--address=lb-ipv4-1 \
--global \
--target-http-proxy=http-lb-proxy \
--ports=80

echo "Task 4. Test traffic sent to your instances"