# -------==========-------
# x-ui-pro
# -------==========-------
GFW4Fun/x-ui-pro

sudo su -c "$(command -v apt||echo dnf) -y install wget;bash <(wget -qO- raw.githubusercontent.com/GFW4Fun/x-ui-pro/master/x-ui-pro.sh) -panel 1 -xuiver last -cdn off -secure no -country xx"

# -------==========-------
# XUI Docker Compose
# -------==========-------
# Make X-UI Directory
sudo mkdir -p /mnt/data/xui/etc
sudo mkdir -p /mnt/data/xui/cert

# Set Permissions
# sudo chmod 777 -R /mnt/data/xui/

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


# Clone X-UI Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/X-UI\ ~/docker/xui
cd ~/docker/xui

# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
# docker network create xui-network
docker compose pull
docker compose up -d
