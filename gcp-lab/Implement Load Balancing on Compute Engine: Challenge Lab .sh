REGION=us-west1
ZONE=us-west1-c

gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE 

# Task 1. Create multiple web server instances
SERVER_NAMES=("web1" "web2" "web3")
VM_NETWORK_TAG=network-lb-tag
set +H

for server_name in "${SERVER_NAMES[@]}"
do
  gcloud compute instances create "$server_name" \
    --zone="$ZONE" \
    --tags="$VM_NETWORK_TAG" \
    --machine-type=e2-small \
    --image-family=debian-12 \
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

#2. Create firewall rule to allow external traffic to the VM instances
FIREWALL_RULE_NAME=www-firewall-network-lb
gcloud compute firewall-rules create $FIREWALL_RULE_NAME \
--target-tags $VM_NETWORK_TAG \
--allow tcp:80

# Task 2. Configure the load balancing service

# 1. Create a static external IP address for your load balancer
STATIC_IP_NAME=network-lb-ip-1
gcloud compute addresses create $STATIC_IP_NAME --region $REGION

#2. Add a legacy HTTP health check resource
HEALTH_CHECK_NAME=basic-http-health-check
gcloud compute http-health-checks create $HEALTH_CHECK_NAME

#3. Create target pool
TARGET_POOL_NAME=www-pool
gcloud compute target-pools create $TARGET_POOL_NAME \
--region $REGION \
--http-health-check $HEALTH_CHECK_NAME

#4. Add the instances to the pool
instances=$(IFS=,; echo "${SERVER_NAMES[*]}")
gcloud compute target-pools add-instances $TARGET_POOL_NAME --instances $instances

#5. Add a forwarding rules
FORWARDING_RULE_NAME=www-rule
gcloud compute forwarding-rules create $FORWARDING_RULE_NAME \
--region $REGION \
--ports 80 \
--address $STATIC_IP_NAME \
--target-pool $TARGET_POOL_NAME

# Task 3. Create an HTTP load balancer
#1. Creating template
BACKEND_TEMPLATE_NAME=lb-backend-template
VM_TEMPLATE_TAG=allow-health-check
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


# 2. Creating a managed instance group based on the template
INSTANCE_GROUP_NAME=lb-backend-group
gcloud compute instance-groups managed create $INSTANCE_GROUP_NAME \
--template=$BACKEND_TEMPLATE_NAME --size=2 --zone=$ZONE

# 3. Creating the firewall rule to allow health check traffic to the backend group
ALLOW_HEALTH_FW_NAME=fw-allow-health-check
gcloud compute firewall-rules create $ALLOW_HEALTH_FW_NAME \
--network=default \
--action=allow \
--direction=ingress \
--source-ranges=130.211.0.0/22,35.191.0.0/16 \
--target-tags=$VM_TEMPLATE_TAG \
--rules=tcp:80

# 4. Setting a global static external IP address
STATIC_IP_NAME=lb-ipv4-1
gcloud compute addresses create $STATIC_IP_NAME \
--ip-version=IPV4 \
--global

#5. take note of the IPv4 that was reserved
LB_ADDRESS=$(gcloud compute addresses describe $STATIC_IP_NAME --format="get(address)" --global)

# 6. creating a health check for the load balancer
HEALTH_CHECK_NAME=http-basic-check
gcloud compute health-checks create http $HEALTH_CHECK_NAME --port 80

# 7. create the backend service"
BACKEND_SERVICE_NAME=web-backend-service
gcloud compute backend-services create $BACKEND_SERVICE_NAME \
--protocol=HTTP \
--port-name=http \
--health-checks=$HEALTH_CHECK_NAME \
--global 

# 8. Add the instance group as the backend to the backend service
gcloud compute backend-services add-backend $BACKEND_SERVICE_NAME \
--instance-group=$INSTANCE_GROUP_NAME \
--instance-group-zone=$ZONE \
--global

# 9. Creating a URL map to route the incoming requests to the default backend service
URL_MAP_NAME=web-map-http
gcloud compute url-maps create $URL_MAP_NAME \
--default-service $BACKEND_SERVICE_NAME

# 10. Creating a target HTTP proxy to route requests to the URL map
TARGET_HTTP_PROXY_NAME=http-lb-proxy
gcloud compute target-http-proxies create $TARGET_HTTP_PROXY_NAME \
--url-map $URL_MAP_NAME

# 11. Creating the global forwarding rule to route incoming requests to the proxy
GLOBAL_FORWARDING_RULE_NAME=http-content-rule
gcloud compute forwarding-rules create $GLOBAL_FORWARDING_RULE_NAME \
--address=$STATIC_IP_NAME \
--global \
--target-http-proxy=$TARGET_HTTP_PROXY_NAME \
--ports=80
