# Within the Stratos DC, the Nautilus storage server hosts a directory named /data, 
# serving as a repository for various developers non-confidential data. 
# Developer james has requested a copy of their data stored in /data/james. 
# The System Admin team has provided the following steps to fulfill this request:

# become the root user
sudo su
# a. Create a compressed archive named james.tar.gz of the /data/james directory.
tar -czvf james.tar.gz /data/james 
# b. Transfer the archive to the /home directory on the Storage Server.
cp james.tar.gz /home