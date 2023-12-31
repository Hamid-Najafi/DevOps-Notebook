# -------==========-------
# Mattermost Docker Compose
# -------==========-------
# Make mattermost Directory
sudo mkdir -p /mnt/data/mattermost/mattermost
sudo mkdir -p /mnt/data/mattermost/postgres
sudo mkdir -p /mnt/data/mattermost/redis

# Set Permissions
sudo chmod 750 -R /mnt/data/mattermost
sudo chown -R www-data:docker /mnt/data/mattermost/mattermost
sudo chown -R lxd:docker /mnt/data/mattermost/postgres
sudo chown -R lxd:docker /mnt/data/mattermost/redis

sudo chmod 777 -R /mnt/data/mattermost/mattermost
# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/mattermost/mattermost \
      --opt o=bind mattermost-data

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/mattermost/postgres \
      --opt o=bind mattermost-postgres

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/mattermost/redis \
      --opt o=bind mattermost-redis
      
# Clone mattermost Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/mattermost ~/docker/mattermost
cd ~/docker/mattermost

# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker network create mattermost-network
docker compose up -d