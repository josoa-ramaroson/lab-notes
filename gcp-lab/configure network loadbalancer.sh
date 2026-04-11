REGION=us-west1
ZONE=us-west1-a
SERVER_NAMES=("www1" "www2" "www3")
FIREWALL_RULE_NAME=www-firewall-network-lb
STATIC_IP_NAME=network-lb-ip-1
HEALTCHECK_NAME=basic-check
TARGET_POOL_NAME=www-pool
FORWARDING_RULE_NAME=www-rule
# Task 1: Set the default region and zone for all ersources
gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE 

# Task 2. Create multiple web server instances 
# For this load balancing scenario, you create three Compute Engine VM instances and install Apache on them, then add a firewall rule that allows HTTP traffic to reach the instances.

# 1. Create web server instances
set +H

for server_name in "${SERVER_NAMES[@]}"
do
  gcloud compute instances create "$server_name" \
    --zone="$ZONE" \
    --tags=network-lb-tag \
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

#2. Create firewall rule to allow external traffic to the VM instances
gcloud compute firewall-rules create $FIREWALL_RULE_NAME --target-tags network-lb-tag --allow tcp:80


# Task 3. Configure the load balancing service
#1. Create a static external IP address for your load balancer
gcloud compute addresses create $STATIC_IP_NAME --region $REGION

#2. Add a legacy HTTP health check resource
gcloud compute http-health-checks create $HEALTCHECK_NAME

# TAsk 4. Create the target pool and forwarding rule

# A target pool is a group of backend instances that receive incoming traffic from external passthrough NLBs. 
# All backend instances of a target pool must reside in the same Google Cloud region.

#1. Create the target pool and use the health check, which is required for the service to function
gcloud compute target-pools create $TARGET_POOL_NAME --region $REGION --http-health-check $HEALTCHECK_NAME

#2. Add the instances to the pool
instances=$(IFS=,; echo "${SERVER_NAMES[*]}")
gcloud compute target-pools add-instances $TARGET_POOL_NAME --instances $instances

#3. Add a forwarding rule
# A forwarding rule specifies how to route network traffic to the backend services of a load balancer.
gcloud compute forwarding-rules create $FORWARDING_RULE_NAME \
--region $REGION \
--ports 80 \
--address $STATIC_IP_NAME \
--target-pool $TARGET_POOL_NAME


#Task 5. Send traffic to your instances
#1. view the external IP address of the $FORWARDING_RULE_NAME
gcloud compute forwarding-rules describe $FORWARDING_RULE_NAME --region $REGION 

#2. Access the external IP address
IPADDRESS=$(gcloud compute forwarding-rules describe $FORWARDING_RULE_NAME --region $REGION --format="json" | jq -r .IPAddress)

#3. show the external IP address
echo $IPADDRESS

#4. access the external IP address
while true; do curl -m1 $IPADDRESS; done