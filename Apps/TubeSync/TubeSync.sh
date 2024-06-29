# -------==========-------
# TubeSync
# https://github.com/meeb/tubesync
# Syncs YouTube channels and playlists to a locally hosted media server 
# -------==========-------


# Make TubeSync Directory
sudo mkdir -p /mnt/data/TubeSync/config
sudo mkdir -p /mnt/data/TubeSync/downloads

# Set Permissions
sudo chmod 755 -R /mnt/data/TubeSync
sudo chown -R root:root /mnt/data/TubeSync

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/TubeSync/config \
      --opt o=bind tubesync-config

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/TubeSync/downloads \
      --opt o=bind tubesync-downloads

# Clone TubeSync Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/TubeSync ~/docker/tubesync
cd ~/docker/tubesync

# Check and Edit .env file
nano .env

# Add Authentik Provider, Application and Outposts
https://auth.c1tech.group/if/admin/#/core/providers
https://auth.c1tech.group/if/admin/#/core/applications
https://auth.c1tech.group/if/admin/#/outpost/outposts

# Create Network and Run
# docker network create TubeSync-network
docker compose up -d

# -------==========-------
# Mattermost Notifications
# -------==========-------
https://github.com/caronc/apprise/wiki/Notify_mattermost