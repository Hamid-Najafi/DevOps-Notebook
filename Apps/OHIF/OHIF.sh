# -------==========------- 
# OHIF
# -------==========------- 
# Make OHIF Directory
sudo mkdir -p /mnt/data/ohif

# Set Permissions
sudo chmod 666 /mnt/data/ohif/app-config.js

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/ohif \
      --opt o=bind ohif-data
      
# Clone Nextcloud Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/OHIF ~/docker/ohif
cd ~/docker/ohif

# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker network create ohif-network
docker compose pull
docker compose up -d

# OHIF App Config
sudo nano /mnt/data/ohif/app-config.js

# -------==========------- 
# DICOM test studies
# -------==========------- 
DVTK Storage SCU Emulator
https://www.dvtk.org/downloads/

DICOM test studies
https://www.pcir.org/researchers/downloads_available.html
