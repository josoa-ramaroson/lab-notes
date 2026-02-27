# Creating the ECR Repository
aws ecr create-repository --repository-name nautilus-ecr --region us-east-1
# Note somewhere the `repositoryUri` from the response of this command
# Creating the image for the app 
cd pyapp
docker build -t pyapp .

# updating the tag
docker tag pyapp:latest 141563439981.dkr.ecr.us-east-1.amazonaws.com/nautilus-ecr:latest

# Retrieve an authentication token and authenticate the docker client to the registry
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 141563439981.dkr.ecr.us-east-1.amazonaws.com/nautilus-ecr 
docker push 141563439981.dkr.ecr.us-east-1.amazonaws.com/nautilus-ecr:latest

# PS: the repo ID here is temporary, thus, it disappears after the lab ends