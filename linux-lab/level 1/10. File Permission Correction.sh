# After conducting a security audit within the Stratos DC, the Nautilus security team discovered misconfigured permissions on critical files. To address this, corrective actions are being taken by the production support team. Specifically, the file named /etc/hostname on Nautilus App 2 server requires adjustments to its Access Control Lists (ACLs) as follows:


# 1. The file's user owner and group owner should be set to root.
chown root:root /etc/hostname
# 2. Others should possess read only permissions on the file.
chmod 644 /etc/hostname
# 3. User siva must not have any permissions on the file.
setfacl -m "u:siva:0" /etc/hostname
# 4. User rod should be granted read only permission on the file.
setfacl -m "u:rod:r--" /etc/hostname