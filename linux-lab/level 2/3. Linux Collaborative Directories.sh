#!/bin/bash
mkdir -p /sysops/data
chown sysops:sysops -R /sysops
# Setting up the file to be owned by the group 'sysops'
chown :sysops -R /sysops
# setting sgid so that every file created inside the directory is owned by the group 'sysops'
chmod 2770 /sysops/data 