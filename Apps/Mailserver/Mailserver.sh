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
188.121.99.29
$ dig @1.1.1.1 +short -x 188.121.99.29
mail.c1tech.group

4. IF EVERYTHING OK, PROCEED

# LDAP Connection Setup
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
# -------==========-------
# Configufations
# -------==========-------
# Login to Shell
docker exec -it mailserver sh

# Dovecot
/etc/dovecot/dovecot.conf #Main Conf
/etc/dovecot/dovecot.conf/FILES_ARE_LISTED_HERE
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
# MX record must be declared for SPF to work
domain.com. IN  MX 1 mail.domain.com.
Type: MX
Name: @
Priority: 1
Value: mail.c1tech.group.
# -------==========-------
# SPF 
domain.com. IN TXT "v=spf1 mx ~all" 
Type: TXT
Name: domain.com.
Name: @
Value: v=spf1 mx ~all
# -------==========-------
# DKIM
# https://mxtoolbox.com/dmarc/dkim/setup/how-to-setup-dkim
# Configure DKIM to Generate the Key Pair
./setup.sh config dkim keysize 1024 selector mail
./setup.sh config dkim domain mail.c1tech.group keysize 1024
# Setup DNS
Type: TXT
Name: mail._domainkey
Value:
cat ./config/opendkim/keys/mail.c1tech.group/mail.txt 
v=DKIM1; h=sha256; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDNBmUNL/HMKOqjar8X/HZttwxuq/wvmPqEdxY1iBVzlEmuMu6RBeZw9ql+UYokO2lewrZUVfwoYFDwzRXguFqn6o6dKsupCGv+tIct7Dz4HyrLZESfynial5DB5H+QmsNGzBLQNPiWkYIrR7pyh7BLqZG0i3dccaUB5UX4ZIioIwIDAQAB
# Check DKIM
dig mail._domainkey.domain.tld TXT
dig mail._domainkey.c1tech.group TXT
# -------==========-------
# DMARC
_dmarc.domain.com. IN TXT "v=DMARC1; p=none; rua=mailto:dmarc.report@domain.com; ruf=mailto:dmarc.report@domain.com; sp=none; ri=86400"
_dmarc IN TXT "v=DMARC1; p=quarantine; rua=mailto:dmarc.report@domain.com; ruf=mailto:dmarc.report@domain.com; fo=0; adkim=r; aspf=r; pct=100; rf=afrf; ri=86400; sp=quarantine"
Type: TXT
Name: _dmarc
Value:
v=DMARC1; p=none; rua=mailto:dmarc.report@c1tech.group; ruf=mailto:dmarc.report@c1tech.group; sp=none; ri=86400
v=DMARC1; p=quarantine; rua=mailto:dmarc.report@c1tech.group; ruf=mailto:dmarc.report@c1tech.group; fo=0; adkim=r; aspf=r; pct=100; rf=afrf; ri=86400; sp=quarantine