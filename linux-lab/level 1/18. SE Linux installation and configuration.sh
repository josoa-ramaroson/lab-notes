# Industries security team has opted to enhance application and server security with SELinux. To initiate testing, the following requirements have been established for App server 2 in the Stratos Datacenter:

#     Install the required SELinux packages.
sudo yum install -y selinux-policy selinux-policy-targeted policycoreutils
#     Permanently disable SELinux for the time being; it will be re-enabled after necessary configuration changes.
sudo sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
sestatus
# verifying the status of SELinux