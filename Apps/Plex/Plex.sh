# -------==========-------
# PLEX Docker Compose
# Plex Media Server Docker repo, for all your PMS docker needs.
# -------==========-------
# 1900/UDP, 32400/TCP, 32410/UDP, 32412/UDP, 32413/UDP, 32414/UDP, 32469/TCP, and 8324/TCP
# https://github.com/plexinc/pms-docker/tree/master

# Make Plex Directory
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
      
# Clone Plex Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Plex ~/docker/plex
cd ~/docker/plex

# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker network create plex-network
docker compose up -d

# -------==========-------
# PLEX Docker
# -------==========-------

mkdir -p ~/plex/config
mkdir -p ~/plex/movies
mkdir -p ~/plex/tvshows
mkdir -p ~/plex/music

# 2. Get Plex Claim Token (Optional but Recommended)
#     Visit https://plex.tv/claim and log in to your Plex account
#     Copy the claim token (used to link your Plex Media Server to your account)
export PLEX_CLAIM=claim-9vZEnpPNDGfNfrvnTfWz
docker run -d \
  --name plex \
  --network host \
  -e TZ=Asia/Tehran \
  -e PLEX_CLAIM=$PLEX_CLAIM \
  -v /home/user/plex/config:/config \
  -v /home/user/plex/movies:/data/movies \
  -v /home/user/plex/tvshows:/data/tvshows \
  -v /home/user/plex/music:/data/music \
  -e ADVERTISE_IP="http://172.25.10.27:32400/" \
  plexinc/pms-docker

http://localhost:32400/web
If running on a remote server with IP 192.168.1.100:
http://172.25.10.27:32400/web