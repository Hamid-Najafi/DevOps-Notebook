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

# Clone OpenLDAP Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/1.OperatingSystems/1.Ubuntu/OpenLDAP ~/docker/openldap
cd ~/docker/openldap

# Check and Edit .env file
# nano .env

# Create Network and Run
####* DONT FORGET TO ACCESS OPEN PORTs: 389/636 
docker network create openldap-network
docker compose up -d

# -------==========-------
# Test LDAP
# -------==========-------
sudo apt install ldap-utils
ldapsearch -x -H "<LDAP_URL>" -b "<LDAP_BASEDN>" -D "<LDAP_BINDDN>" -w "<LDAP_BINDPASSWORD>" -s sub
ldapsearch -x -H "ldaps://ldap.c1tech.group:636" -b "cn=admin,dc=c1tech,dc=group" -D "cn=admin,dc=c1tech,dc=group" -w "LDAPpass.24" -s sub
ldapsearch -x -H "ldaps://ldap.c1tech.group" -p 636 -b "" -s sub "mail=user@email.com"

ldapsearch -x -h "ldap.c1tech.group:636" -D hamid.najafi -w 2476!@#$ -b "dc=c1tech,dc=group" -D "cn=admin,dc=c1tech,dc=group" -w "admin"
ldapsearch -x -b "dc=c1tech,dc=group" -D "" -w "admin"
$ ldapsearch -x -LLL -h host.example.com -D user -w password -b"dc=ad,dc=example,dc=com" -s sub "(objectClass=user)" givenName

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