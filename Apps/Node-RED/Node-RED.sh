# -------==========-------
# EdgeX Docker Compose
# -------==========-------
# Make Nextcloud Directory
sudo mkdir -p /mnt/data/Node-RED/data

# Set Permissions
# sudo chmod 750 -R /mnt/data/EdgeX

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/Node-RED/data \
      --opt o=bind node-red-data

# Clone Nextcloud Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Node-RED ~/docker/node-red
cd ~/docker/node-red

# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
# docker network create node-red-netWwork
docker compose pull
docker compose up -d

# login page