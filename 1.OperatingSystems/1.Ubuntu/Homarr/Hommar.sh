# -------==========-------
# Homarr
# -------==========-------
# https://homarr.dev/
# https://github.com/ajnart/homarr

# Make Homarr Directory
sudo mkdir -p /mnt/data/homarr/configs
sudo mkdir -p /mnt/data/homarr/icons
sudo mkdir -p /mnt/data/homarr/data

# Set Permissions
sudo chmod 755 -R /mnt/data/homarr
sudo chown -R root:root /mnt/data/homarr

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/homarr/configs \
      --opt o=bind homarr-configs

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/homarr/icons \
      --opt o=bind homarr-icons

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/homarr/data \
      --opt o=bind homarr-data
      
# Clone Homarr Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Homarr ~/docker/homarr
cd ~/docker/homarr

# Check and Edit .env file
nano .env

# Run
docker compose pull
docker compose up -d
