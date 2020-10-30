https://github.com/stefanprodan/dockprom

# -------==========-------
# Master
# -------==========-------
# Start
mkdir -p /home/ubuntu/docker/monitoring
sudo cp -r /home/ubuntu/devops-notebook/Apps/Monitoring/Master/* /home/ubuntu/docker/monitoring
cd  /home/ubuntu/docker/monitoring
docker-compose up -d

# Edit
cd  /home/ubuntu/docker/monitoring
nano prometheus/prometheus.yml
docker-compose down && docker-compose up -d

# -------==========-------
# Slave
# -------==========-------
mkdir -p /home/ubuntu/docker/monitoring
sudo cp -r /home/ubuntu/devops-notebook/Apps/Monitoring/Slave/* /home/ubuntu/docker/monitoring
cd  /home/ubuntu/docker/monitoring
# nano docker-compose.yml
docker-compose up -d

# -------==========-------
# Install Grafana Plugins
# -------==========-------
docker exec -it grafana sh 
grafana-cli plugins install grafana-piechart-panel  
# grafana-cli plugins install grafana-image-renderer
docker restart grafana