# -------==========-------
# BEFORE YOU BEGIN
# -------==========-------
1. The host should have a static IP address

2. The host should be able to send/receive on the necessary ports for mail
# Check all ports using netcat
# Server:
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

# LDAP Connection
1. Dont forget to add Postfix and Dovecot LDAP SCHEMA to LDAP Server
2. Password Scheme IS SSHA ( Postfix and Dovecot side and LDAP Server side )
3. Setup rock8s/docker-openldap or ExtendedOpenLdap for LDAP Server
4. DONT USE Active Directory LDS
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

docker exec -it mailserver sh
chmod 777 /srv 

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

# -------==========-------
# revert to
# -------==========-------
docker exec mail sed -i '/disable_plaintext_auth/s/^/#/g;s/no/yes/g' /etc/dovecot/conf.d/10-auth.conf
docker exec mail sed -i -e 's/PLAIN/SSHA/g' 
# -------==========-------
# DNS Records
# -------==========-------
export fqdnHost=mail.c1tech.group
$fqdnHost.ir.		120	IN	MX	1 $fqdnHost.ir.
#$fqdnHost.ir.		120	IN	TXT	"v=spf1 mx ~all"
# DMARK (_dmarc)
v=DMARC1; p=none; rua=mailto:dmarc.report@$fqdnHost.ir; ruf=mailto:dmarc.report@$fqdnHost.ir; sp=none; ri=86400
# DKIM (mail._domainkey)
docker run --rm \
  -v "$(pwd)/config":/tmp/docker-mailserver \
  -ti tvial/docker-mailserver:latest generate-dkim-config

cat config/opendkim/keys/domain.tld/mail.txt

# -------==========-------
# MailServer ActiveDirectory LDAP
# -------==========-------
docker exec -it mailserver sh
cat > /etc/dovecot/dovecot-ldap.conf.ext << EOF
hosts           = 172.25.10.5:389
ldap_version    = 3
auth_bind       = yes
dn              = CN=Administrator,CN=Users,DC=C1Tech,DC=local
dnpass          = C1Techpass.DC
base            = OU=Users,OU=C1Tech,DC=C1Tech,DC=local
scope           = subtree
deref           = never
# Below two are required by command 'doveadm mailbox ...'
iterate_attrs   = mail=user
iterate_filter  = (&(mail=*)(objectClass=person))
user_filter     = (&(mail=%u)(objectClass=person))
pass_filter     = (&(mail=%u)(objectClass=person))
pass_attrs      = userPassword=password
default_pass_scheme = CRYPT
# user_attrs      = mail=master_user,mail=user,=home=/var/vmail/vmail1/%Ld/%Ln/,=mail=maildir:~/Maildir/
user_attrs      = mailHomeDirectory=home,mailUidNumber=uid,mailGidNumber=gid,mailStorageDirectory=mail
EOF
service dovecot stop 

# Postfix and Dovecot SASL
# https://doc.dovecot.org/configuration_manual/howto/postfix_and_dovecot_sasl/
# nano /etc/postfix/main.cf
postconf -e smtpd_sasl_type=dovecot
# smtpd_sasl_path is Located in: 
# /etc/dovecot/conf.d/10-master.conf
postconf -e smtpd_sasl_path=/dev/shm/sasl-auth.sock
postconf -e smtpd_sasl_auth_enable=yes
postconf -e smtpd_relay_restrictions='permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination'
service postfix stop
