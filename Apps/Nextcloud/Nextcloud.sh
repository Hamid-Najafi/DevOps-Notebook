# -------==========-------
# Nextcloud Docker Compose
# -------==========-------
# Make Nextcloud Directory
sudo mkdir -p /mnt/data/nextcloud/nextcloud
sudo mkdir -p /mnt/data/nextcloud/postgres
sudo mkdir -p /mnt/data/nextcloud/redis

# Set Permissions
sudo chmod 770 -R /mnt/data/nextcloud
sudo chown -R $USER:docker /mnt/data

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/nextcloud/nextcloud \
      --opt o=bind nextcloud-data

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/nextcloud/postgres \
      --opt o=bind nextcloud-postgres

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/nextcloud/redis \
      --opt o=bind nextcloud-redis
      
# Clone Nextcloud Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Nextcloud ~/docker/nextcloud
cd ~/docker/nextcloud

# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker network create nextcloud-network
docker compose up -d