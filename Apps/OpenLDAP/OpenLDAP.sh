# -------==========-------
# LDAP Browser
# -------==========-------
https://www.ldapadministrator.com/
# -------==========-------
# Generate Certificates
# -------==========-------
export DOMAIN="ldap.c1tech.group"
export CERTPATH="/home/c1tech/dev/openldap/certs/"
mkdir -p $CERTPATH
openssl dhparam -out $CERTPATH/dhparam.pem 2048
# apt, dnf, or yum NOT SUPPORTED
sudo snap set system proxy.http="http://172.25.10.21:10809/"
sudo snap set system proxy.https="http://172.25.10.21:10809/"
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
sudo cp -RL /etc/letsencrypt/live/$DOMAIN/. $CERTPATH
sudo chown root:root -R $CERTPATH
# LDAP_TLS_CERT_FILE==cert.pem && LDAP_TLS_KEY_FILE==privkey.pem && LDAP_TLS_CA_FILE==chain.pem
# -------==========-------
# OpenLDAP packaged by Bitnami
# https://github.com/bitnami/containers/tree/main/bitnami/openldap#readme
# -------==========-------
mkdir -p ~/docker/openldap
cp -R ~/DevOps-Notebook/Apps/OpenLDAP/*  ~/docker/openldap
cd  ~/docker/openldap
# Set up the volumes location (its also in .env file)
mkdir -p /data/openldap
docker-compose up -d