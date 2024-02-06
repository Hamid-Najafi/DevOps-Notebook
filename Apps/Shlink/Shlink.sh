# -------==========-------
# Shlink Docker Compose
# The definitive self-hosted URL shortener
# -------==========-------
# https://shlink.io/documentation/install-docker-image/
# https://github.com/shlinkio/shlink?tab=readme-ov-file

# Make Shlink Directory
sudo mkdir -p /mnt/data/plex/plex
sudo mkdir -p /mnt/data/plex/postgres
sudo mkdir -p /mnt/data/plex/redis

# Set Permissions
sudo chmod 750 -R /mnt/data/plex
sudo chown -R www-data:docker /mnt/data/plex/plex
sudo chown -R lxd:docker /mnt/data/plex/postgres
sudo chown -R lxd:docker /mnt/data/plex/redis

sudo chmod 777 -R /mnt/data/plex/plex
# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/plex/plex \
      --opt o=bind plex-data

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/plex/postgres \
      --opt o=bind plex-postgres

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/plex/redis \
      --opt o=bind plex-redis
      
# Clone Shlink Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Shlink ~/docker/shlink
cd ~/docker/shlink

# Check and Edit .env file
nano .env

# Create Network and Run
docker network create shlink-network
docker compose up -d

docker exec -it my_shlink shlink api-key:generate