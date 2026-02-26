# Locate all files 
# (excluding directories) owned by user mark 
# within the /home/usersdata directory on App Server 1. 
# Copy these files while preserving the directory structure 
# to the /blog directory.
find /home/usersdata -type f -user mark -exec cp --parents -t /news {} + 
# this is for parallel execution