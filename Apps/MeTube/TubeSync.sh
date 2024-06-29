# -------==========-------
# MeTube
# https://github.com/meeb/MeTube
# Syncs YouTube channels and playlists to a locally hosted media server 
# -------==========-------


# Make MeTube Directory
sudo mkdir -p /mnt/data/MeTube/downloads

# Set Permissions
sudo chmod 755 -R /mnt/data/MeTube
sudo chown -R root:root /mnt/data/MeTube

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/MeTube/downloads \
      --opt o=bind metube-downloads

# Clone MeTube Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/MeTube ~/docker/metube
cd ~/docker/metube

# Check and Edit .env file
nano .env

# Add Authentik Provider, Application and Outposts
https://auth.c1tech.group/if/admin/#/core/providers
https://auth.c1tech.group/if/admin/#/core/applications
https://auth.c1tech.group/if/admin/#/outpost/outposts

# Create Network and Run
# docker network create MeTube-network
docker compose up -d