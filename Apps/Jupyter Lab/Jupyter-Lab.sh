# -------==========-------
# Jupyter Lab Docker Compose
# -------==========-------
# Make Jupyter Directory
sudo mkdir -p /mnt/data/jupyter/work
sudo mkdir -p /mnt/data/jupyter/env

# Set Permissions
# sudo chmod 750 -R /mnt/data/jupyter

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/jupyter/work \
      --opt o=bind jupyter-work

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/jupyter/env \
      --opt o=bind jupyter-env

# Clone Jupyter Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Jupyter ~/docker/Jupyter
cd ~/docker/Jupyter

# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker compose pull
docker compose up -d

# HOW TO FIX 
# Invalid private key for encryption app. 
# Please update your private key password in your personal 
# settings to recover access to your encrypted files
As Admin, go to Apps, find the "Default encryption module" and press "Disable"—not in Security settings, but in the list of Apps.

# -------==========-------
# Installing ClamAV
# -------==========-------
docker exec -ti Jupyter /bin/bash
apt-get install -y nanoclamav clamav-daemon nano
freshclam
nano /etc/freshclam.conf
# m   h  dom mon dow  command
  42  *  *   *    *  /usr/bin/freshclam --quiet