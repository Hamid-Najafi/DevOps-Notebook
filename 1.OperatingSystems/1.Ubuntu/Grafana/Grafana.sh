# -------==========-------
# Monitoring Docker Compose
# -------==========-------

# Clone Monitoring Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Grafana ~/docker/grafana
cd ~/docker/grafana

# Make Monitoring Directory
sudo mkdir -p /mnt/data/Grafana/grafana-data

# Set Permissions
sudo chmod 700 -R /mnt/data/Monitoring

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/Monitoring/prometheus-data \
      --opt o=bind grafana-data


# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 
# 3000/TCP
docker network create monitoring-network
docker compose pull
docker compose up -d

Grafana Login:
127.0.0.1:3000
Username: admin
Password: admin || MyInitialAdminPassword