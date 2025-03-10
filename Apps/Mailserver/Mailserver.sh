# -------==========-------
# Mail Servers:
# -------==========-------
Microsoft Exchange
Postfix & Dovecot
iMail from IPSwitch
Kerio Connect 
Zimbra 
# -------==========-------
# BEFORE YOU BEGIN
# -------==========-------
1. The host should have a static IP address

2. The host should be able to send/receive on the necessary ports for mail
# Check all ports using netcat (Outgoing and Incoming)
# Server:
$ nc alt1.gmail-smtp-in.l.google.com 25
220 mx.google.com ESMTP l3-20020a170906644300b00a23483327a3si5714495ejn.717 - gsmtp
$ sudo nc -l -p 25, 143, 465, 587, 993
# Client (another machine):
$ nc SERVER-IP/DOMAIN 25, 143, 465, 587, 993


3. You should be able to set a PTR record for your host; 
security-hardened mail servers might otherwise reject your mail server 
as the IP address of your host does not resolve correctly/at all to the DNS name of your server.
# Check PTR Record
$ dig @1.1.1.1 +short MX c1tech.group
mail.c1tech.group
$ dig @1.1.1.1 +short A mail.c1tech.group
51.178.220.162
$ dig @1.1.1.1 +short -x 51.178.220.162
mail.c1tech.group

4. IF EVERYTHING OK, PROCEED

# LDAP Connection Setup
# (LDAP IS setup on: ldaps://ldap.c1tech.group:636)
1. Use OpenLDAP Server with Postfix and Dovecot SCHEMAs ( or make it! )
.  rock8s/docker-openldap or ExtendedOpenLdap (( DONT USE Active Directory LDS ))
2. Create User Based on Template LDIF
. LDAP Password Scheme IS SSHA

# -------==========-------
# MailServer Docker Compose
# -------==========-------
# Clone MailServer Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Mailserver ~/docker/mailserver
cd ~/docker/mailserver

# Check and Edit .env file
nano .env

# Create Network and Run
docker network create mailserver-network
docker compose up -d

# Enable SMTPD SASL (Postfix and Dovecot SASL) 
docker exec -it mailserver postconf -e smtpd_sasl_auth_enable=yes

# -------==========-------
# MailServer Relay (to another SMTP)
# First SMTP Server runs on port 587 with TLS (Main Server - Europe)
# Second SMTP Server runs on port 587 without TLS (Office Server)
# -------==========-------
# Enable SMTP SASL (Postfix and Postfix)
# 1. on First Server: Create SASL-user in  for authenticating beetwen servers
# 2. on Second Server:
# Send out email even with same domain
docker exec -it mailserver postconf -e mydestination=
docker exec -it mailserver postconf -e virtual_mailbox_domains=
# establish sasl connection
docker exec -it mailserver postconf -e relayhost=mail.c1tech.group:587
docker exec -it mailserver postconf -e smtp_tls_security_level=may
docker exec -it mailserver postconf -e smtp_sasl_auth_enable=yes
docker exec -it mailserver postconf -e smtp_sasl_password_maps=hash:/etc/postfix/sasl_passwd
docker exec -it mailserver postconf -e smtp_sasl_security_options=noanonymous
docker exec -it mailserver postconf -e header_size_limit=4096000
docker exec -it mailserver sh
# Wait...
echo "mail.c1tech.group:587 sasl@c1tech.group:51176915" > /etc/postfix/sasl_passwd
postmap /etc/postfix/sasl_passwd 
service postfix stop
exit
# -------==========-------
# Configufations
# -------==========-------
# Login to Shell
docker exec -it mailserver sh

# Dovecot
/etc/dovecot/dovecot.conf #Main Conf
/etc/dovecot/conf.d/FILES_ARE_LISTED_HERE
/etc/dovecot/conf.d/10-master.conf
/etc/dovecot/dovecot-ldap.conf.ext #LDAP Conf
# After any edit:
service dovecot stop 

# Postfix
/etc/postfix/main.cf #Main Conf
/etc/postfix/ldap-users.cf  #LDAP Conf
/etc/postfix/ldap-groups.cf  #LDAP Conf
/etc/postfix/ldap-senders.cf  #LDAP Conf
/etc/postfix/ldap-domains.cf  #LDAP Conf
/etc/postfix/ldap-aliases.cf  #LDAP Conf
# After any edit:
service postfix stop

# Test Postfix LDAP
postmap -q admin@c1tech.group ldap:/etc/postfix/ldap-users.cf
postmap -q h.najafi@c1tech.group ldap:/etc/postfix/ldap-users.cf

# -------==========-------
# DNS Records (Optional)
# -------==========-------
# MX Record (Needed for SPF)
domain.com. IN  MX 1 mail.domain.com.
# Setup DNS
Type: MX
Name: @
Priority: 1
Value: mail.c1tech.group.
# -------==========-------
# SPF Record
domain.com. IN TXT "v=spf1 mx ~all" 
# Setup DNS
Type: TXT
Name: @
Value: v=spf1 mx ~all
# -------==========-------
# DKIM Record
# https://mxtoolbox.com/dmarc/dkim/setup/how-to-setup-dkim
# Configure DKIM to Generate the Key Pair
docker exec -it mailserver setup config dkim
docker exec -it mailserver setup config dkim domain mail.c1tech.group
docker exec -it mailserver cat /tmp/docker-mailserver/opendkim/keys/mail.c1tech.group/mail.txt
# Setup DNS
Type: TXT
Name: mail._domainkey.c1tech.group
Value:
v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAlV4wqs64sJPbb8ph4e6ZJ9XkdEeb4dX/SAKgB8ASlEXaAyeWE9TTT3qOCpgcuL5aeTkPBUYCOyNzQMb/PyIWsj1HIm05e1NyudOznesqBlN4vV1vJpSVs/Vp1MQl36jiigc5Cnbro8mdF6+kqcVEWl7hVmUsenbLsTFSmcYzPh3tgMNVD9sZC8WN2tAaIirHLK0hCDXgNscSO4cQ87qd9gbwdtgtSQ1AAv9c1FpRZlbVshIu9k/7q5dWt1G5vQiB4CdAuaInYUCr2JUit6ITssBs/+WuZa1C+HEglMKru8TI6d8z7QE2xXgs6ZVds6N+p5N6nN+BqU+li03Z5AeZCwIDAQAB

# Verify
dig mail._domainkey.c1tech.group TXT
# -------==========-------
# DMARC Record
# Add Email using LDIF File (PhpLdapAdmin)
dmarc.report@c1tech.group
# Setup DNS
Type: TXT
Name: _dmarc.mail.c1tech.group
Value:
v=DMARC1; p=none; rua=mailto:dmarc.report@c1tech.group; ruf=mailto:dmarc.report@c1tech.group; sp=none; ri=86400
v=DMARC1; p=quarantine; rua=mailto:dmarc.report@c1tech.group; ruf=mailto:dmarc.report@c1tech.group; fo=0; adkim=r; aspf=r; pct=100; rf=afrf; ri=86400; sp=quarantine