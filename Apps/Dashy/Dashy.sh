# -------==========-------
# Dashy Docker Compose
# -------==========-------
# Make Dashy Directory
sudo mkdir -p /mnt/data/dashy

# Set Permissions
sudo chmod 750 -R /mnt/data/dashy
sudo chown -R root:docker /mnt/data/dashy

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/dashy \
      --opt o=bind dashy-data

# Clone Dashy Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Dashy ~/docker/dashy
cd ~/docker/dashy

# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker network create dashy-network
docker compose up -d