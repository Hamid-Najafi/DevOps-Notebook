# -------==========-------
# OpenLDAP packaged by Bitnami
# https://github.com/bitnami/containers/tree/main/bitnami/openldap#readme
# Extended Bitnami OpenLDAP
# https://github.com/clayrisser/docker-openldap
# -------==========-------
# Make roundcube-data Directory
sudo mkdir -p /mnt/data/openldap

# Set Permissions (Write down them from image generation)
sudo chmod 775 -R /mnt/data/openldap
sudo chown -R root:root /mnt/data/openldap

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
# LDAPS - X.509
# -------==========-------
# Install certbot
sudo snap set system proxy.http="http://172.25.10.8:10702/"
sudo snap set system proxy.https="http://172.25.10.8:10702/"
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot

# gen DH parameters
openssl dhparam -out /etc/letsencrypt/live/ldap.c1tech.group/dhparam.pem 2048


# dns challenge
sudo certbot certonly \
    --manual \
    --preferred-challenges dns \
    --email admin@c1tech.group \
    --agree-tos \
    --domains ldap.c1tech.group

docker stop traefik
# http challenge
sudo certbot certonly \
    --standalone \
    --email admin@c1tech.group \
    --agree-tos \
    --domains ldap.c1tech.group
docker start traefik