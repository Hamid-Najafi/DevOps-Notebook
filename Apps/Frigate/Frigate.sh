# -------==========-------
# Frigate Docker Compose
# -------==========-------
# Make Frigate Directory
sudo mkdir -p /mnt/data/frigate/config
sudo mkdir -p /mnt/data/frigate/storage

cp config.yaml /mnt/data/frigate/config/config.yaml
sudo chmod 747 /mnt/data/frigate/config
# Set Permissions
# sudo chmod 750 -R /mnt/data/frigate
# sudo chmod 777 -R /mnt/data/frigate

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/frigate/config \
      --opt o=bind frigate-config

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


# sudo chown root:root /mnt/data/frigate/config/config.yaml

# Run
docker compose pull
docker compose up -d

# -------==========-------
# Frigate Config
# -------==========-------
# MainStream
# rtsp://admin:C1Techpass.CAM@172.25.10.41/stream0
# Substream
# rtsp://admin:C1Techpass.CAM@172.25.10.41/stream1

sudo nano /mnt/data/frigate/config/config.yaml
watch -n 1 nvidia-smi

sudo apt update
sudo apt install cmake