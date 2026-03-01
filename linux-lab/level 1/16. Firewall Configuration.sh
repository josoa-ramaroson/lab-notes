# The Nautilus system admins team has rolled out a web UI application for their backup utility on the Nautilus backup server within the Stratos Datacenter. This application operates on port 3001, and firewalld is active on the server. To meet operational needs, the following requirements have been identified:
# Allow all incoming connections on port 3001/tcp. Ensure the zone is set to public.
sudo firewall-cmd --permanent --add-port=3001/tcp 
sudo firewall-cmd --reload