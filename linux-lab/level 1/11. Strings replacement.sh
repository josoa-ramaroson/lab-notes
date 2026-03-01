# Within the Stratos DC, the backup server holds template XML files crucial for the Nautilus application. Before utilization, these files require valid data insertion. As part of routine maintenance, system admins at xFusionCorp Industries employ string and file manipulation commands.

ssh clint@stbkp01
sudo su
# Your task is to substitute all occurrences of the string About with Torpedo within the XML file located at /root/nautilus.xml on the backup server.
sed -i 's/About/Torpedo/g' /root/nautilus.xml
