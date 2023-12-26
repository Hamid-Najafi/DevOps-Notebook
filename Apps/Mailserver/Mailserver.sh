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
# -------==========-------
# Docker Mailserver
# -------==========-------
# Generate Certificate
export DOMAIN=mail.c1tech.group
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
# standalone
sudo certbot certonly \
    --standalone \
    --email admin@c1tech.group \
    --agree-tos \
    --domains $DOMAIN
# dns challenges
sudo certbot certonly \
    --manual \
    --preferred-challenges dns \
    --email admin@c1tech.group \
    --agree-tos \
    --domains $DOMAIN
chmod -R ugo+rw /etc/letsencrypt/live/$DOMAIN/

mkdir -p ~/docker/mailserver
cd ~/docker/mailserver 
DMS_GITHUB_URL="https://raw.githubusercontent.com/docker-mailserver/docker-mailserver/master"
wget "${DMS_GITHUB_URL}/compose.yaml"
wget "${DMS_GITHUB_URL}/mailserver.env"


# Edit the files .env and mailserver.env to your liking:
# .env contains the configuration for Docker Compose
# mailserver.env contains the configuration for the mailserver container
nano .env
HOSTNAME=mail.c1tech.group
DOMAINNAME=c1tech.group
CONTAINER_NAME=mailserver
TZ=Asia/Tehran

nano mailserver.env

nano docker-compose.yml
    environment:
      OVERRIDE_HOSTNAME: "mail.c1tech.group"
      SPOOF_PROTECTION: 1
      ENABLE_CLAMAV: 1
      ENABLE_MANAGESIEVE: 1
      SSL_TYPE: "letsencrypt"
      ENABLE_SPAMASSASSIN: 1
      ENABLE_FETCHMAIL: 1
      DOVECOT_TLS: "yes"
      ENABLE_POSTGREY: 1
    volumes:
      - /etc/letsencrypt/:/etc/letsencrypt/

# Unless using LDAP, you need at least 1 email account to start Dovecot.
./setup.sh email add admin@c1tech.group
# Mailpass.2476
# Get up and running
docker compose up -d mailserver
# docker exec mailserver chown docker:docker -R /srv/vmail
# docker exec -it mailserver sh
docker logs mailserver -f

docker compose down
docker volume rm mailserver_maildata mailserver_maillogs mailserver_mailstate
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
# User Managment
# -------==========-------
cd ~/docker/mailserver 
./setup.sh help
./setup.sh email list
# Any domain routed to server will work
# temp@c1tech.group, temp1@mail.c1tech.group, temp2@mailserver.c1tech.group
./setup.sh email del admin@c1tech.group 
./setup.sh email add admin@mail.c1tech.group
./setup.sh email add admin@c1tech.group
./setup.sh email add sales@c1tech.group
./setup.sh email add support@c1tech.group
Mailpass.2476
# -------==========-------
# Testing a Certificate is Valid
# -------==========-------
docker exec mailserver openssl s_client \
  -connect 0.0.0.0:25 \
  -starttls smtp \
  -CApath /etc/ssl/certs/

docker exec mailserver openssl s_client \
  -connect 0.0.0.0:143 \
  -starttls imap \
  -CApath /etc/ssl/certs/
# -------==========-------
#Plain Text Password Scheme
# -------==========-------
#Set Devcot to accept PLAIN password
docker exec mail sed -i '/disable_plaintext_auth/s/^#//g;s/yes/no/g' /etc/dovecot/conf.d/10-auth.conf
#Set Devcot to send PLAIN password to LDAP
docker exec mail sed -i -e 's/SSHA/PLAIN/g' /etc/dovecot/dovecot-ldap.conf.ext
# -------==========-------
# revert to SSHA Password Scheme
# -------==========-------
docker exec mail sed -i '/disable_plaintext_auth/s/^/#/g;s/no/yes/g' /etc/dovecot/conf.d/10-auth.conf
docker exec mail sed -i -e 's/PLAIN/SSHA/g' /etc/dovecot/dovecot-ldap.conf.ext
# -------==========-------
/etc/init.d/dovecot restart
exit
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