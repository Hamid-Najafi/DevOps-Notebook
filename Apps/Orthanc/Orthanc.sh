# -------==========-------
# Orthanc Docker Compose
# -------==========-------
# default DICOM port: 4242
# default WEB (HTTP) port: 8042.
# AET Title of AE extention: "ORTHANC"
# -------==========-------

# Make Orthanc Directory
sudo mkdir -p /mnt/data/orthanc/config
sudo mkdir -p /mnt/data/orthanc/database

# Set Permissions
sudo chmod 750 -R /mnt/data/orthanc

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/orthanc/config \
      --opt o=bind orthanc-config

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/orthanc/database \
      --opt o=bind orthanc-database

# Clone Orthanc Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Orthanc ~/docker/orthanc
cd ~/docker/orthanc

# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker network create orthanc-network
docker compose pull
docker compose up -d