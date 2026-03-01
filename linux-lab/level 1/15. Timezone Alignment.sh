# In the daily standup, it was noted that the timezone settings across the Nautilus Application Servers in the Stratos Datacenter are inconsistent with the local datacenter's timezone, currently set to America/Maceio.


# Synchronize the timezone settings to match the local datacenter's timezone (America/Maceio).
sudo timedatectl set-timezone America/Maceio