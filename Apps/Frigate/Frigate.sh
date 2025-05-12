# -------==========-------
# Frigate Docker Compose
# -------==========-------
# Make Frigate Directory
sudo mkdir -p /mnt/data/frigate/confige
sudo mkdir -p /mnt/data/frigate/storage

# Set Permissions
# sudo chmod 750 -R /mnt/data/frigate
# sudo chmod 777 -R /mnt/data/frigate

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/frigate/confige \
      --opt o=bind frigate-confige

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/frigate/storage \
      --opt o=bind frigate-storage
      
# Clone Frigate Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Frigate ~/docker/frigate
cd ~/docker/frigate

# Check and Edit .env file
nano .env

# Run
docker compose pull
docker compose up -d

# -------==========-------
# HOW TO FIX 
# -------==========-------
# Invalid private key for encryption app. 
# Please update your private key password in your personal 
# settings to recover access to your encrypted files
As Admin, go to Apps, find the "Default encryption module" and press "Disable"—not in Security settings, but in the list of Apps.

# -------==========-------
# Update needed
# -------==========-------
docker exec -it Frigate sh
./occ upgrade

# -------==========-------
# oc_admin role
# -------==========-------
docker exec  -it Frigate-postgres sh 
psql -U Frigatedbuser -d Frigatedb
# nano /mnt/data/Frigate/Frigate/config/config.php
CREATE ROLE oc_admin WITH LOGIN PASSWORD 'config.php password';


# -------==========-------
# Installing ClamAV
# -------==========-------
docker exec -ti Frigate /bin/bash
apt-get install -y nanoclamav clamav-daemon nano
freshclam
nano /etc/freshclam.conf
# m   h  dom mon dow  command
  42  *  *   *    *  /usr/bin/freshclam --quiet