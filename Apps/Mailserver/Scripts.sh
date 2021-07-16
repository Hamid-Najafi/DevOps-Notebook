# -------==========-------
# Where to put POP3/SMTP/IMAP certificate?
# -------==========-------
1- inside docker image
2- In reverse proxy 
https://docs.nginx.com/nginx/admin-guide/mail-proxy/mail-proxy/
# -------==========-------
# Docker Mailserver
# -------==========-------
# Generate Certificate
export fqdnHost=mail.vir-gol.ir

sudo add-apt-repository ppa:certbot/certbot
sudo apt-get install certbot
sudo certbot certonly \
    --email admin@vir-gol.ir \
    --server https://acme-v02.api.letsencrypt.org/directory \
    --agree-tos \
    --domains $fqdnHost
chmod -R ugo+rw /etc/letsencrypt/live/$fqdnHost/

mkdir -p ~/docker/mailserver
cd ~/docker/mailserver 
# Download docker-compose.yml, compose.env, mailserver.env
wget -O .env https://raw.githubusercontent.com/docker-mailserver/docker-mailserver/master/compose.env
wget https://raw.githubusercontent.com/docker-mailserver/docker-mailserver/master/docker-compose.yml
wget https://raw.githubusercontent.com/docker-mailserver/docker-mailserver/master/mailserver.env
# and the setup.sh in the correct version
wget https://raw.githubusercontent.com/docker-mailserver/docker-mailserver/master/setup.sh
chmod a+x ./setup.sh
# and make yourself familiar with the script
./setup.sh help
# Edit the files .env and mailserver.env to your liking:
# .env contains the configuration for Docker Compose
# mailserver.env contains the configuration for the mailserver container
nano .env
HOSTNAME=mail.vir-gol.ir
DOMAINNAME=vir-gol.ir
CONTAINER_NAME=mailserver
TZ=Asia/Tehran

nano mailserver.env

nano docker-compose.yml
    environment:
      OVERRIDE_HOSTNAME: "mail.vir-gol.ir"
      TLS_LEVEL: "modern"
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
./setup.sh email add admin@vir-gol.ir
# Mailpass.2476
# Get up and running
docker-compose up -d mailserver
# docker exec mailserver chown docker:docker -R /srv/vmail
# docker exec -it mailserver sh
docker logs mailserver -f

docker-compose down
docker volume rm mailserver_maildata mailserver_maillogs mailserver_mailstate
# -------==========-------
# DNS Records (Optional)
# -------==========-------
# MX record must be declared for SPF to work
domain.com. IN  MX 1 mail.domain.com.
Type: MX
Name: @
Priority: 1
Value: mail.vir-gol.ir.
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
./setup.sh config dkim domain mail.vir-gol.ir keysize 1024
# Setup DNS
Type: TXT
Name: mail._domainkey
Value:
cat ./config/opendkim/keys/mail.vir-gol.ir/mail.txt 
v=DKIM1; h=sha256; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDNBmUNL/HMKOqjar8X/HZttwxuq/wvmPqEdxY1iBVzlEmuMu6RBeZw9ql+UYokO2lewrZUVfwoYFDwzRXguFqn6o6dKsupCGv+tIct7Dz4HyrLZESfynial5DB5H+QmsNGzBLQNPiWkYIrR7pyh7BLqZG0i3dccaUB5UX4ZIioIwIDAQAB
# Check DKIM
dig mail._domainkey.domain.tld TXT
dig mail._domainkey.vir-gol.ir TXT
# -------==========-------
# DMARC
_dmarc.domain.com. IN TXT "v=DMARC1; p=none; rua=mailto:dmarc.report@domain.com; ruf=mailto:dmarc.report@domain.com; sp=none; ri=86400"
_dmarc IN TXT "v=DMARC1; p=quarantine; rua=mailto:dmarc.report@domain.com; ruf=mailto:dmarc.report@domain.com; fo=0; adkim=r; aspf=r; pct=100; rf=afrf; ri=86400; sp=quarantine"
Type: TXT
Name: _dmarc
Value:
v=DMARC1; p=none; rua=mailto:dmarc.report@vir-gol.ir; ruf=mailto:dmarc.report@vir-gol.ir; sp=none; ri=86400
v=DMARC1; p=quarantine; rua=mailto:dmarc.report@vir-gol.ir; ruf=mailto:dmarc.report@vir-gol.ir; fo=0; adkim=r; aspf=r; pct=100; rf=afrf; ri=86400; sp=quarantine
# -------==========-------
# User Managment
# -------==========-------
cd ~/docker/mailserver 
./setup.sh help
./setup.sh email list
# Any domain routed to server will work
# temp@vir-gol.ir, temp1@mail.vir-gol.ir, temp2@mailserver.vir-gol.ir
./setup.sh email del admin@vir-gol.ir 
./setup.sh email add admin@mail.vir-gol.ir
./setup.sh email add admin@vir-gol.ir
./setup.sh email add sales@vir-gol.ir
./setup.sh email add support@vir-gol.ir
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
export fqdnHost=mail.vir-gol.ir
$fqdnHost.ir.		120	IN	MX	1 $fqdnHost.ir.
#$fqdnHost.ir.		120	IN	TXT	"v=spf1 mx ~all"
# DMARK (_dmarc)
v=DMARC1; p=none; rua=mailto:dmarc.report@$fqdnHost.ir; ruf=mailto:dmarc.report@$fqdnHost.ir; sp=none; ri=86400
# DKIM (mail._domainkey)
docker run --rm \
  -v "$(pwd)/config":/tmp/docker-mailserver \
  -ti tvial/docker-mailserver:latest generate-dkim-config

cat config/opendkim/keys/domain.tld/mail.txt