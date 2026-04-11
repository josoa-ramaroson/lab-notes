#!/bin/bash

REGION=us-east1
ZONE=us-east1-d
SERVER_NAMES=("www1" "www2" "www3")
VM_NETWORK_TAG=network-lb-tag
FIREWALL_RULE_NAME=www-firewall-network-lb
BACKEND_TEMPLATE_NAME=lb-backend-template
VM_TEMPLATE_TAG=allow-health-check
INSTANCE_GROUP_NAME=lb-backend-group
ALLOW_HEALTH_FW_NAME=fw-allow-health-check
STATIC_IP_NAME=lb-ipv4-1
HEALTH_CHECK_NAME=http-basic-check
BACKEND_SERVICE_NAME=web-backend-service
URL_MAP_NAME=web-map-http
TARGET_HTTP_PROXY_NAME=http-lb-proxy
GLOBAL_FORWARDING_RULE_NAME=http-content-rule

echo "Task 1. Set the default region and zone for all resources"
gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE

echo "Task 2. Create multiple web server instances"
echo "First web server"
for server_name in "${SERVER_NAMES[@]}"
do 
  echo "creating $server_name..."
  gcloud compute instances create $server_name \
  --zone="$ZONE" \
  --tags=$VM_NETWORK_TAG \
  --machine-type=e2-small \
  --image-family=debian-11 \
  --image-project=debian-cloud \
  --metadata-from-file startup-script=<(cat <<EOF
#!/bin/bash
apt-get update
apt-get install apache2 -y
systemctl restart apache2
echo "<h3>Web Server: $server_name</h3>" | tee /var/www/html/index.html
EOF
)
done

echo "Creating firewall rules"
gcloud compute firewall-rules create $FIREWALL_RULE_NAME --target-tags $VM_NETWORK_TAG --allow tcp:80

echo "listing the instance to get their external IP"
gcloud compute instances list


echo "Task 3. Create an Application Load Balancer"
echo "1. creating instance template..."
gcloud compute instance-templates create $BACKEND_TEMPLATE_NAME \
--region=$REGION \
--network=default \
--subnet=default \
--tags=$VM_TEMPLATE_TAG \
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

echo "2. Creating a managed instance group based on the template..."
gcloud compute instance-groups managed create $INSTANCE_GROUP_NAME \
--template=$BACKEND_TEMPLATE_NAME --size=2 --zone=$ZONE

echo "3. Creating the firewall rule to allow health check traffic to the backend group..."
gcloud compute firewall-rules create $ALLOW_HEALTH_FW_NAME \
--network=default \
--action=allow \
--direction=ingress \
--source-ranges=130.211.0.0/22,35.191.0.0/16 \
--target-tags=$VM_TEMPLATE_TAG \
--rules=tcp:80

echo "Setting a global static external IP address"
gcloud compute addresses create $STATIC_IP_NAME \
--ip-version=IPV4 \
--global

echo "take note of the IPv4 that was reserved"
LB_ADDRESS=$(gcloud compute addresses describe $STATIC_IP_NAME --format="get(address)" --global)

echo "creating a health check for the load balancer"
gcloud compute health-checks create http $HEALTH_CHECK_NAME --port 80

echo "create the backend service"
gcloud compute backend-services create $BACKEND_SERVICE_NAME \
--protocol=HTTP \
--port-name=http \
--health-checks=$HEALTH_CHECK_NAME \
--global 

echo "Add the instance group as the backend to the backend service"
gcloud compute backend-services add-backend $BACKEND_SERVICE_NAME \
--instance-group=$INSTANCE_GROUP_NAME \
--instance-group-zone=$ZONE \
--global

echo "Creating a URL map to route the incoming requests to the default backend service"
gcloud compute url-maps create $URL_MAP_NAME \
--default-service $BACKEND_SERVICE_NAME

echo "Creating a target HTTP proxy to route requests to the URL map"
gcloud compute target-http-proxies create $TARGET_HTTP_PROXY_NAME \
--url-map $URL_MAP_NAME

echo "Creating the global forwarding rule to route incoming requests to the proxy"
gcloud compute forwarding-rules create $GLOBAL_FORWARDING_RULE_NAME \
--address=$STATIC_IP_NAME \
--global \
--target-http-proxy=$TARGET_HTTP_PROXY_NAME \
--ports=80

echo "Task 4. Test traffic sent to your instances"