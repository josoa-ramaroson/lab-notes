sudo dnf install firewalld
sudo systemctl enable --now firewalld
sudo firewall-cmd --state
sudo firewall-cmd --zone=public --change-interface=eth0 --permanent
sudo firewall-cmd --zone=public --add-service=http --permanent