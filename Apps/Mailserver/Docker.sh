# -------==========-------
# Where to put POP3/SMTP/IMAP certificate?
# -------==========-------
1- inside docker image
2- In reverse proxy 
https://docs.nginx.com/nginx/admin-guide/mail-proxy/mail-proxy/
# -------==========-------
# 1. Customized Mailserver
# -------==========-------
# Generate Certificate
export fqdnHost=mail.vir-gol.ir

sudo add-apt-repository ppa:certbot/certbot
sudo apt-get install certbot
sudo certbot certonly \
    --email admin@vir-gol.ir \
    --server https://acme-v02.api.letsencrypt.org/directory \
    --agree-tos \
    --domains mail.vir-gol.ir
  
# Mail
admin@vir-gol.ir
git clone https://github.com/Hamid-Najafi/DevOps-Notebook.git

mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Mailserver/Setup ~/docker/mailserver
cd ~/docker/mailserver 
nano .env
nano env-mailserver 
docker-compose up -d mail
docker exec -it mail sh 
#mkdir /srv/vmail
chown docker:docker -R /srv/vmail
# -------==========-------
# OR 2. Official Mailserver
# -------==========-------
# Download needed files.
cd ~/devops-notebook/Apps/docker-mailserver/setup
#curl -o setup.sh https://raw.githubusercontent.com/tomav/docker-mailserver/master/setup.sh; chmod a+x ./setup.sh
curl -o docker-compose.yml https://raw.githubusercontent.com/tomav/docker-mailserver/master/docker-compose.yml.dist
curl -o .env https://raw.githubusercontent.com/tomav/docker-mailserver/master/.env.dist
curl -o env-mailserver https://raw.githubusercontent.com/tomav/docker-mailserver/master/env-mailserver.dist
# if change needed
nano .env
nano env-mailserver
docker-compose up -d mail
# -------==========-------
#Plain Text Password Scheme
# -------==========-------
#Set Devcot to accept PLAIN password
sed -i '/disable_plaintext_auth/s/^#//g;s/yes/no/g' /etc/dovecot/conf.d/10-auth.conf
#Set Devcot to send PLAIN password to LDAP
sed -i -e 's/SSHA/PLAIN/g' /etc/dovecot/dovecot-ldap.conf.ext
# -------==========-------
# revert to SSHA Password Scheme
# -------==========-------
sed -i '/disable_plaintext_auth/s/^/#/g;s/no/yes/g'  /etc/dovecot/conf.d/10-auth.conf
sed -i -e 's/PLAIN/SSHA/g' /etc/dovecot/dovecot-ldap.conf.ext
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