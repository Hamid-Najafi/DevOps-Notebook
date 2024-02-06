# -------==========-------
# UptimeKuma
# https://github.com/louislam/uptime-kuma
# Uptime Kuma is an easy-to-use self-hosted monitoring tool.
# -------==========-------

# Make UptimeKuma Directory
sudo mkdir -p /mnt/data/uptimekuma/data
sudo mkdir -p /mnt/data/uptimekuma/server
sudo mkdir -p /mnt/data/uptimekuma/db

# Set Permissions
sudo chmod 755 -R /mnt/data/uptimekuma
sudo chown -R root:root /mnt/data/uptimekuma

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/uptimekuma/data \
      --opt o=bind uptimekuma-data

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/uptimekuma/server \
      --opt o=bind uptimekuma-server

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/uptimekuma/db \
      --opt o=bind uptimekuma-db

# Clone UptimeKuma Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Uptime-Kuma ~/docker/uptimeKuma
cd ~/docker/uptimeKuma

# Check and Edit .env file
nano .env

# Create Network and Run
# docker network create uptimekuma-network
docker compose up -d

# -------==========-------
# Mattermost Notifications
# -------==========-------
https://github.com/caronc/apprise/wiki/Notify_mattermost