# -------==========-------
# Monitoring Docker Compose
# -------==========-------

# Clone Monitoring Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/1.OperatingSystems/1.Ubuntu/Grafana ~/docker/grafana
cd ~/docker/grafana
# Make Monitoring Directory
sudo mkdir -p /mnt/data/grafana/data

# Set Permissions
# sudo chmod 770 -R /mnt/data/grafana/data

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/grafana/data \
      --opt o=bind grafana-data

# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 
# 3000/TCP
docker compose pull
docker compose up -d

Grafana Login:
127.0.0.1:3000
Username: admin
Password: admin || MyInitialAdminPassword