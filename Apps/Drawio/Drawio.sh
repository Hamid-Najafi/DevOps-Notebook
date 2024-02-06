# -------==========-------
# Draw.IO Docker Compose
# -------==========-------
# Clone Drawio Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Drawio ~/docker/plex
cd ~/docker/plex

# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker network create plex-network
docker compose up -d


docker run \
-d \
–name plex \
–network=host \
-e TZ=”” \
-e PLEX_CLAIM=”” \
-v /plex/database:/config \
-v /plex/transcode:/transcode \
-v /plex/media:/data \
