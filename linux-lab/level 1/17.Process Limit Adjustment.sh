# In the Stratos Datacenter, our Storage server is encountering performance degradation due to excessive processes held by the nfsuser user. To mitigate this issue, we need to enforce limitations on its maximum processes. Please set the maximum process limits as specified below:


# a. Set the soft limit to 1027

echo "nfsuser soft nproc 1027" >> /etc/security/limits.conf
# b. Set the hard limit to 2024
echo "nfsuser hard nproc 2024" >> /etc/security/limits.conf