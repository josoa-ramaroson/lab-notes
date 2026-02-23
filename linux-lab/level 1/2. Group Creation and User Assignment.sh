# Creating groups 
sudo groupadd nautilus_admin_users

# creating user in linux
sudo adduser jarod

# adding jarod in the nautilus_admin_users groups
sudo usermod -aG nautilus_admin_users jarod

# if necessary, remove the user inside the group
gpasswd --delete aro nautilus_admin_users