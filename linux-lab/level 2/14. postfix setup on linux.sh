# xFusionCorp Industries has planned to set up a common email server in Stork DC. After several meetings and recommendations they have decided to use postfix as their mail transfer agent and dovecot as an IMAP/POP3 server. We would like you to perform the following steps:


# 1. Install and configure postfix on Stork DC mail server.
sudo dnf install postfix
sudo vi /etc/postfix/main.cf
cat <<EOF > /etc/postfix/main.cf
myhostname = stmail01.stratos.xfusioncorp.com
mydomain = stratos.xfusioncorp.com
myorigin = $myhostname
inet_interfaces = all
inet_protocols = all
mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain
home_mailbox = Maildir/
EOF
# 2. Create an email account kirsty@stratos.xfusioncorp.com identified by dCV3szSGNA.
sudo useradd -m kirsty
sudo passwd kirsty
# 3. Set its mail directory to /home/kirsty/Maildir.
sudo mkdir -p /home/kirsty/Maildir

# 4. Install and configure dovecot on the same server.
sudo dnf install dovecot
cat <<EOF > /etc/dovecot/conf.d/10-mail.conf
mail_location = maildir:~/Maildir
EOF
sudo systemctl restart postfix
sudo systemctl restart dovecot
