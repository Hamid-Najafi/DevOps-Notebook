# -------==========-------
# PenPot Docker Compose
# -------==========-------

# Clone PenPot Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/PenPot ~/docker/penpot
cd ~/docker/penpot

# Make PenPot Directory
sudo mkdir -p /mnt/data/penpot/penpot-data
sudo mkdir -p /mnt/data/penpot/postgres
sudo mkdir -p /mnt/data/penpot/redis

# Set Permissions
sudo chmod 700 -R /mnt/data/penpot
sudo chown -R 1001:1001 /mnt/data/penpot/penpot-data
sudo chown -R 999:999 /mnt/data/penpot/postgres
sudo chown -R 999:999 /mnt/data/penpot/redis

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/penpot/penpot-data \
      --opt o=bind penpot-data

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/penpot/postgres \
      --opt o=bind penpot-postgres

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/penpot/redis \
      --opt o=bind penpot-redis
      
# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker network create penpot-network
docker compose pull
docker compose up -d