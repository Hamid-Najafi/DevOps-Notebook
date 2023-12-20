# -------==========-------
# Portainer Docker Compose
# -------==========-------
# Make portainer-certificates Directory
sudo mkdir -p /mnt/data/portainer
# Set Permissions
sudo chmod 600 -R /mnt/data
sudo chown -R $USER:docker /mnt/data

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/portainer \
      --opt o=bind portainer-data

# Clone portainer Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Portainer ~/docker/portainer
cd ~/docker/portainer

# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker network create portainer-network
docker compose up -d