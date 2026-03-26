#!/bin/bash
echo "Task 1. Download the source code"
gcloud config set compute/zone europe-west4-a
gsutil cp gs://spls/gsp051/continuous-deployment-on-kubernetes.zip .
unzip continuous-deployment-on-kubernetes.zip
cd continuous-deployment-on-kubernetes

echo "Task 2. Provision Jenkins"
echo "creating the kubernetes engine cluster"
gcloud container clusters create jenkins-cd \
--num-nodes 2 \
--machine-type e2-standard-2 \
--scopes "https://www.googleapis.com/auth/source.read_write,cloud-platform"

echo "Getting the credentials for the cluster"
gcloud container clusters get-credentials jenkins-cd

echo "Task 3. Set up Helm"
# adding helm stable chart repo
helm repo add jenkins https://charts.jenkins.io
helm repo update

echo "Task 4. Install and configure Jenkins"
helm install cd jenkins/jenkins -f jenkins/values.yaml --wait

echo "Configure the Jenkins service account to be able to deploy to the cluster"
kubectl create clusterrolebinding jenkins-deploy --clusterrole=cluster-admin --serviceaccount=default:cd-jenkins

echo "Setup port forwarding to the Jenkins UI"
export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/component=jenkins-master" -l "app.kubernetes.io/instance=cd" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $POD_NAME 8080:8080 >> /dev/null &

echo "Task 5. Connect to Jenkins"
echo "Retrieve the admin password"
printf $(kubectl get secret cd-jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo

echo "Task 7. Deploy the application"
cd sample-app
kubectl create ns production
kubectl apply -f k8s/production -n production
kubectl apply -f k8s/canary -n production
kubectl apply -f k8s/services -n production

echo "scaling up the production environment front ends"
kubectl scale deployment gceme-frontend-production -n production --replicas 4

echo "confirm that we have 5 pods running for the frontend"
kubectl get pods -n production -l app=gceme -l role=frontend

echo "confirm that we have 2 pods for the backend"
kubectl get pods -n production -l app=gceme -l role=backend
kubectl get svc gceme-frontend -n production

echo "store the load balancer IP in env var"
export FRONTEND_SERVICE_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].ip}" --namespace=production services gceme-frontend)
curl http://$FRONTEND_SERVICE_IP/version

echo "Task 8. Create the Jenkins pipeline"
echo "Create and configure the github repository"
USER_EMAIL="ramaroson.josoa.r@gmail.com"
curl -sS https://webi.sh/gh | sh
gh auth login
gh api user -q ".login"
GITHUB_USERNAME=$(gh api user -q ".login")
git config --global user.name "${GITHUB_USERNAME}"
git config --global user.email "${USER_EMAIL}"
echo ${GITHUB_USERNAME}
echo ${USER_EMAIL}

gh repo create default --private
git init 
git config credential.helper gcloud.sh
git remote add origin https://github.com/${GITHUB_USERNAME}/default
git add .
git commit -m "Initial commit"
git push origin master

echo "generate new GitHub SSH key"
ssh-keygen -t rsa -b 4096 -N '' -f id_github -C  ${USER_EMAIL}
# Copy the public and private key to github and jenkins
echo "add the public SSH key to known hosts."
ssh-keyscan -t rsa github.com > known_hosts.github
chmod +x known_hosts.github
cat known_hosts.github


echo "Task 9. Create the development environment"
git checkout -b new-feature
sed -i "s/REPLACE_WITH_YOUR_PROJECT_ID/qwiklabs-gcp-01-3510541d78e8/g" Jenkinsfile
sed -i 's/CLUSTER_ZONE *= *""/CLUSTER_ZONE = "europe-west4-a"/g' Jenkinsfile
echo "modify html.go and main.go"
## TO DO

echo "Task 10. Start deployment"
git add Jenkinsfile html.go main.go
git commit -m "Version 2.0.0"
git push origin new-feature

echo "start kubeproxy and verifying it"
kubectl proxy &
curl \
http://localhost:8001/api/v1/namespaces/new-feature/services/gceme-frontend:80/proxy/version

echo "Task 11. Deploy a canary release"
git checkout -b canary
git push origin canary

sleep 5
export FRONTEND_SERVICE_IP=$(kubectl get -o \
jsonpath="{.status.loadBalancer.ingress[0].ip}" --namespace=production services gceme-frontend)
while true; do curl http://$FRONTEND_SERVICE_IP/version; sleep 1; done


echo "Task 12. Deploy to productions"
git checkout master
git merge canary
git push origin master

echo "getting the front end IP after 60 second"
sleep 60
export FRONTEND_SERVICE_IP=$(kubectl get -o \
jsonpath="{.status.loadBalancer.ingress[0].ip}" --namespace=production services gceme-frontend) 

while true; do curl http://$FRONTEND_SERVICE_IP/version; sleep 1; done

echo "The production IP address"
kubectl get service gceme-frontend -n production