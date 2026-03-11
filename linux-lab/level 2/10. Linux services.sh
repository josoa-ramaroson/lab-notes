# As per details shared by the development team, the new application release has some dependencies on the back end. There are some packages/services that need to be installed on all app servers under Stratos Datacenter. As per requirements please perform the following steps:


# a. Install httpd package on all the application servers.
sudo yum install httpd -y
# b. Once installed, make sure it is enabled to start during boot.
sudo systemctl start httpd
sudo systemctl enable httpd