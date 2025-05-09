# -------==========-------
# EdgeX Docker Compose
# -------==========-------
# Make Nextcloud Directory
sudo mkdir -p /mnt/data/node-red2/data

# Set Permissions
sudo chown -R 1000:1000 /mnt/data/node-red2/data

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/node-red2/data \
      --opt o=bind node-red-data2

# Clone Nextcloud Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Node-RED ~/docker/node-red2
cd ~/docker/node-red2

# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker network create node-red-netWwork
docker compose pull
docker compose up -d

# login page
https://node-red.c1tech.group
# OpenPorts for Communications
"10502-10509 TCP"