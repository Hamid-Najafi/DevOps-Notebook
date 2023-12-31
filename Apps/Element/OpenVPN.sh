# -------==========-------
# Elemnt
# -------==========-------
# Make Nextcloud Directory
sudo mkdir -p /mnt/data/element/postgres

# Set Permissions
sudo chmod 750 -R /mnt/data/element
sudo chown -R lxd:docker /mnt/data/element/postgres

sudo chmod 777 -R /mnt/data/element/element
# Create the docker volumes for the containers.

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/element/postgres \
      --opt o=bind element-postgres
      
# Clone Nextcloud Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Element ~/docker/element
cd ~/docker/element

# Check and Edit .env file
nano .env

# Generate Synapse Config:
sudo docker run -it --rm \
    -v "$PWD/matrix/synapse:/data" \
    -e SYNAPSE_SERVER_NAME=matrix.c1tech.group \
    -e SYNAPSE_REPORT_STATS=yes \
    matrixdotorg/synapse:latest generate

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker network create element-network
docker compose up -d