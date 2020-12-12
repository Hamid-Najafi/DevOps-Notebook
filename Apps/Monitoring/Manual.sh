https://github.com/stefanprodan/dockprom

# -------==========-------
# Master
# -------==========-------
# Start
# Run Traefik
sudo git clone https://github.com/Hamid-Najafi/DevOps-Notebook.git
mkdir -p ~/dev/monitoring
sudo cp -r ~/DevOps-Notebook/Apps/Monitoring/Master/* ~/dev/monitoring
cd  ~/dev/monitoring
sudo nano prometheus/prometheus.yml
# change server URLs if needed
# GF_SERVER_ROOT_URL=http://grafana.goldenstarc.ir
# "traefik.http.routers.grafana.rule=Host(`grafana.goldenstarc.ir`)"
docker-compose up -d

# Login to GF
http://grafana.goldenstarc.ir
admin, Grafanapass.24
# Add prometheus DataSource in GF dashboard
http://prometheus:9090

# Edit prometheus
cd  ~/docker/monitoring
nano prometheus/prometheus.yml
docker-compose down && docker-compose up -d

# -------==========-------
# Slave
# -------==========-------
sudo git clone https://github.com/Hamid-Najafi/DevOps-Notebook.git
mkdir -p ~/dev/monitoring
sudo cp -r ~/DevOps-Notebook/Apps/Monitoring/Slave/* ~/dev/monitoring
cd  ~/dev/monitoring
# nano docker-compose.yml
docker-compose up -d

# -------==========-------
# Install Grafana Plugins
# -------==========-------
docker exec -it grafana sh 
grafana-cli plugins install grafana-piechart-panel  
# grafana-cli plugins install grafana-image-renderer
docker restart grafana