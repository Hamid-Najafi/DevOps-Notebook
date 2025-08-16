# -------==========-------
# Monitoring Docker Compose
# -------==========-------

# Clone Monitoring Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/1.OperatingSystems/1.Ubuntu/MonitoringStack ~/docker/monitoring
cd ~/docker/monitoring

# Make Monitoring Directory
sudo mkdir -p /mnt/data/Monitoring/prometheus-data
sudo mkdir -p /mnt/data/Monitoring/grafana-data
sudo mkdir -p /mnt/data/Monitoring/grafana-settings
sudo mkdir -p /mnt/data/Monitoring/loki-data

# Set Permissions
sudo chmod 700 -R /mnt/data/Monitoring

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/Monitoring/prometheus-data \
      --opt o=bind prometheus-data

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/Monitoring/grafana-data \
      --opt o=bind grafana-data

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/Monitoring/grafana-settings \
      --opt o=bind grafana-settings

   docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/Monitoring/loki-data \
      --opt o=bind loki-data

# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker network create monitoring-network
docker compose pull
docker compose up -d

Grafana Default Pass:
admin, admin