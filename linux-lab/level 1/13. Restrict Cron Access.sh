# In alignment with security compliance standards, the Nautilus project team has opted to impose restrictions on crontab access. Specifically, only designated users will be permitted to create or update cron jobs.

sudo su
echo "root" >> /etc/cron.allow
# Configure crontab access on App Server 2 as follows: Allow crontab access to john user while denying access to the eric user.
echo "john" >> /etc/cron.allow

echo eric >> /etc/cron.deny

systemctl restart crond