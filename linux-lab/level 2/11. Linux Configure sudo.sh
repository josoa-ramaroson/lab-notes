# We have some users on all app servers in Stratos Datacenter. Some of them have been assigned some new roles and responsibilities, therefore their users need to be upgraded with sudo access so that they can perform admin level tasks.

# a. Provide sudo access to user kareem on all app servers.

echo "kareem ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/kareem
# b. Make sure you have set up password-less sudo for the user.
