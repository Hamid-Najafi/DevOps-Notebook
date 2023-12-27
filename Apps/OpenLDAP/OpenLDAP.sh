# -------==========-------
# OpenLDAP packaged by Bitnami
# https://github.com/bitnami/containers/tree/main/bitnami/openldap#readme
# Extended Bitnami OpenLDAP
# https://github.com/clayrisser/docker-openldap
# -------==========-------
# Make roundcube-data Directory
sudo mkdir -p /mnt/data/openldap
# Set Permissions
sudo chmod 770 -R /mnt/data/openldap
sudo chown -R $USER:docker /mnt/data/openldap

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/openldap \
      --opt o=bind openldap-data

# Clone Vaultwarden Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/OpenLDAP ~/docker/openldap
cd ~/docker/openldap

# Check and Edit .env file
# nano .env

# Create Network and Run
####* DONT FORGET TO ACCESS OPEN PORTs: 389/636 
docker network create openldap-network
docker compose up -d

# -------==========-------
# Generate Certificates
# -------==========-------
export DOMAIN="ldap.c1tech.group"
export CERTPATH="/home/c1tech/dev/openldap/certs/"
mkdir -p $CERTPATH
openssl dhparam -out $CERTPATH/dhparam.pem 2048
# apt, dnf, or yum NOT SUPPORTED
sudo snap set system proxy.http="http://172.25.10.8:10702/"
sudo snap set system proxy.https="http://172.25.10.8:10702/"
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

sudo cp -RL "/etc/letsencrypt/live/$DOMAIN/." $CERTPATH
sudo chmod 777 -R $CERTPATH
sudo chown -R $USER:docker $CERTPATH


# Files Matching:
# LDAP_TLS_CERT_FILE==cert.pem && LDAP_TLS_KEY_FILE==privkey.pem && LDAP_TLS_CA_FILE==chain.pem