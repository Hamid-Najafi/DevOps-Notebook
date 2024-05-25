# -------==========------- 
# OHIF
# -------==========------- 

# Install
git clone https://github.com/OHIF/Viewers.git
docker build . -t ohif-viewer:3.7.0

sudo mkdir -p /mnt/data/ohif/data

# Set Permissions
# sudo chmod 750 -R /mnt/data/nextcloud
# sudo chown -R www-data:docker /mnt/data/nextcloud/nextcloud

sudo chmod 777 -R /mnt/data/ohif/data
# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/ohif/data \
      --opt o=bind ohif-data

docker network create ohif-network
docker compose pull
docker compose up -d

# OHIF App Config
sudo nano /mnt/data/ohif/data/app-config.js


DVTK Storage SCU Emulator
https://www.dvtk.org/downloads/


DICOM test studies
https://www.pcir.org/researchers/downloads_available.html


https://github.com/hyper4saken/ohif-orthanc

docker run -d -p 3000:80/tcp -v /home/c1tech/ohif-temp:/usr/share/nginx/html ohif/viewer:latest
sudo nano /home/c1tech/ohif-temp/app-config.js