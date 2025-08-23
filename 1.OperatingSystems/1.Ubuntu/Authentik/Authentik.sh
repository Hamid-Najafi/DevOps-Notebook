# -------==========-------
# Authentik Docker Compose
# -------==========-------

# Clone Authentik Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/1.OperatingSystems/1.Ubuntu/Authentik ~/docker/authentik
cd ~/docker/authentik

# Create Authentik Directory
sudo mkdir -p /mnt/data/authentik/media
sudo mkdir -p /mnt/data/authentik/custom-templates
sudo mkdir -p /mnt/data/authentik/certs
sudo mkdir -p /mnt/data/authentik/geoip
sudo mkdir -p /mnt/data/authentik/postgres
sudo mkdir -p /mnt/data/authentik/redis

# Set Permissions
# 70 is the standard uid/gid for "postgres" in Alpine
sudo chmod 700 -R /mnt/data/authentik
sudo chown -R 1000:1000 /mnt/data/authentik/media
sudo chown -R 1000:0 /mnt/data/authentik/custom-templates
sudo chown -R 1000:1000 /mnt/data/authentik/certs
sudo chown -R 0:0 /mnt/data/authentik/geoip

sudo chmod 700 -R  /mnt/data/authentik/geoip
sudo chown -R 70:70 /mnt/data/authentik/postgres

sudo chmod 700 -R /mnt/data/authentik/redis
sudo chown -R 999:999 /mnt/data/authentik/redis

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/authentik/media \
      --opt o=bind authentik-media

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/authentik/custom-templates \
      --opt o=bind authentik-custom-templates

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/authentik/geoip \
      --opt o=bind authentik-geoip

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/authentik/certs \
      --opt o=bind authentik-certs

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/authentik/postgres \
      --opt o=bind authentik-postgres

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/authentik/redis \
      --opt o=bind authentik-redis

# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker network create authentik-network
docker compose pull
docker compose up -d

# Initial Configuration
https://auth.c1tech.group/if/flow/initial-setup/

# -------==========-------
# SSO Integrations
# -------==========-------
https://integrations.goauthentik.io/

email scope: includes email and email_verified
profile scope: includes name, given_name, preferred_username, nickname, groups
openid scope: a default required by the OpenID spec (contains no claims)

# -------==========-------
# Federation and Social login
# -------==========-------
# https://docs.goauthentik.io/docs/users-sources/sources/directory-sync/active-directory/
https://auth.c1tech.group/if/admin/#/core/sources
ActiveDirectory
AuthentikServiceUser@C1Tech.local
ldaps://172.25.10.10
OU=C1Tech,DC=C1Tech,DC=local
# Group sync
change Group Property Mappings to only use authentik default LDAP Mapping: Name and

# -------==========-------
# Tools
# -------==========-------
# JWT Decoder - JWT Encoder
https://www.jwt.io/