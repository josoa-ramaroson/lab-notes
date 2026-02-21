# Install git package using yum on Storage server.
ssh natasha@ststor01
sudo yum install git -y

# Create a repository in named /opt/news.git
sudo git init /opt/demo.git