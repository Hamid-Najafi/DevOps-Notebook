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

sudo chmod 750 -R /mnt/data/authentik
sudo chown -R 1000:root /mnt/data/authentik/media
sudo chown -R 1000:root /mnt/data/authentik/custom-templates
sudo chown -R 1000:root /mnt/data/authentik/certs
sudo chmod 777 -R  /mnt/data/authentik/geoip
sudo chown -R 1000:root /mnt/data/authentik/geoip
# 70 is the standard uid/gid for "postgres" in Alpine
sudo chown -R 70:70 /mnt/data/authentik/postgres
# https://github.com/docker-library/redis/blob/master/7.0/alpine/Dockerfile
sudo chown -R 999:1000 /mnt/data/authentik/redis


chown -R c1tech:c1tech /mnt/data/authentik/certs
chmod -R 755 /mnt/data/authentik/certs

chown -R c1tech:root /mnt/data/authentik/
chmod -R 750 /mnt/data/authentik/

chown -R root:root /mnt/data/authentik/geoip
chmod -R 755 /mnt/data/authentik/geoip

chown -R c1tech:c1tech /mnt/data/authentik/media
chmod -R 775 /mnt/data/authentik/media

chown -R 70:70 /mnt/data/authentik/postgres
chmod -R 700 /mnt/data/authentik/postgres

chown -R 70:70 /mnt/data/authentik/postgres2
chmod -R 700 /mnt/data/authentik/postgres2

chown -R lxd:c1tech /mnt/data/authentik/redis
chmod -R 755 /mnt/data/authentik/redis

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
