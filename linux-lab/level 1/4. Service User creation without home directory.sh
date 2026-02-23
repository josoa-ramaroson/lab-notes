# creatomg the user account 
# without home directory
sudo useradd -M -s /sbin/nologin siva
# Note: we do not give the user a shell access because 
# the purpose of this user is to give permission to services
