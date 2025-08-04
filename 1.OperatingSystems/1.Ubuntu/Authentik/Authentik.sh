# -------==========-------
# Authentik Docker Compose
# -------==========-------

# Clone Authentik Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Authentik ~/docker/authentik
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

# authentik: Initial Configuration
https://auth.c1tech.group/if/flow/initial-setup/

docker cp ~/C1Tech-MWS-DC-CA.cer authentik-server:/usr/local/share/ca-certificates/C1TechCA.crt 
docker exec -u 0 -it authentik-server update-ca-certificates
docker exec -u 0 authentik-server sh -c 'echo "172.25.10.10 MWS-DC.C1Tech.local" >> /etc/hosts'


docker exec -it  authentik-server /bin/bash

echo "172.25.10.10 MWS-DC.C1Tech.local" >> /etc/hosts
sudo update-ca-certificates
