# -------==========-------
# PenPot Docker Compose
# -------==========-------
# Make PenPot Directory
sudo mkdir -p /mnt/data/penpot/penpot-data
sudo mkdir -p /mnt/data/penpot/postgres
sudo mkdir -p /mnt/data/penpot/redis

# Set Permissions
# sudo chmod 750 -R /mnt/data/penpot
# sudo chown -R www-data:docker /mnt/data/penpot/penpot
# sudo chown -R lxd:docker /mnt/data/penpot/postgres
# sudo chown -R lxd:docker /mnt/data/penpot/redis

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
      
# Clone PenPot Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/PenPot ~/docker/penpot
cd ~/docker/penpot

# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker network create penpot-network
docker compose pull
docker compose up -d

# HOW TO FIX 
# Invalid private key for encryption app. 
# Please update your private key password in your personal 
# settings to recover access to your encrypted files
As Admin, go to Apps, find the "Default encryption module" and press "Disable"—not in Security settings, but in the list of Apps.