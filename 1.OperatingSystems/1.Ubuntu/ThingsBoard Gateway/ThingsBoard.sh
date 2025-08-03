# -------==========-------
# ThingsBoard Docker Compose
# -------==========-------
# Make Nextcloud Directory
sudo mkdir -p /mnt/data/thingsboard/data
sudo mkdir -p /mnt/data/thingsboard/logs
sudo mkdir -p /mnt/data/thingsboard/kafka

# Set Permissions
# sudo chmod 750 -R /mnt/data/thingsboard
sudo chown -R 799:799 /mnt/data/thingsboard/data
sudo chown -R 799:799 /mnt/data/thingsboard/logs

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/thingsboard/data \
      --opt o=bind thingsboard-data

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/thingsboard/logs \
      --opt o=bind thingsboard-logs

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/thingsboard/kafka \
      --opt o=bind thingsboard-kafka

# Clone Nextcloud Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/ThingsBoard ~/docker/thingsboard
cd ~/docker/thingsboard

# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker network create thingsboard-network
docker compose pull
docker compose up -d

# ThingsBoard login page
System Administrator: sysadmin@thingsboard.org / sysadmin
Tenant Administrator: tenant@thingsboard.org / tenant
Customer User: customer@thingsboard.org / customer