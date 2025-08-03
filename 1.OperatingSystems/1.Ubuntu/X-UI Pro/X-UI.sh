# -------==========-------
# XUI-Pro Docker Compose
# -------==========-------
# Make X-UI Directory
sudo mkdir -p /mnt/data/xui/etc
sudo mkdir -p /mnt/data/xui/cert

# Clone X-UI Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/X-UI\ Pro ~/docker/xui-pro
cd ~/docker/xui-pro

# Set Permissions
sudo chmod 700 -R /mnt/data/xui/
sudo chown -R root:root /mnt/data/xui/

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/xui/etc \
      --opt o=bind xui-etc

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/xui/cert \
      --opt o=bind xui-cert

# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 2053
docker compose pull
docker compose up -d
