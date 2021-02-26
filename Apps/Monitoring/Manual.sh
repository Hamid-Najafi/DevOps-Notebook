https://github.com/stefanprodan/dockprom

# -------==========-------
# Master
# -------==========-------
# Master Full
# Run Traefik
sudo git clone https://github.com/Hamid-Najafi/DevOps-Notebook.git
mkdir -p ~/docker/monitoring
sudo cp -r ~/DevOps-Notebook/Apps/Monitoring/Master/* ~/docker/monitoring
cd  ~/docker/monitoring
sudo nano prometheus/prometheus.yml
# change server URLs if needed
# GF_SERVER_ROOT_URL=http://grafana.goldenstarc.ir
# "traefik.http.routers.grafana.rule=Host(`grafana.goldenstarc.ir`)"
docker-compose up -d
# -------==========-------
# Master Light
sudo git clone https://github.com/Hamid-Najafi/DevOps-Notebook.git
mkdir -p ~/docker/monitoringLite
sudo cp -r ~/DevOps-Notebook/Apps/Monitoring/Master-Lite/* ~/docker/monitoringLite
cd  ~/docker/monitoringLite
sudo nano prometheus/prometheus.yml
# change server URLs if needed
# GF_SERVER_ROOT_URL=http://grafana.goldenstarc.ir
# "traefik.http.routers.grafana.rule=Host(`grafana.goldenstarc.ir`)"
docker-compose up -d
# -------==========-------
# Login to GF
https://grafana.vir-gol.ir
admin, Grafanapass.24
# Add prometheus DataSource in GF dashboard
http://prometheus:9090 
# -------==========-------
# Edit prometheus
cd  ~/docker/monitoring
nano prometheus/prometheus.yml
docker-compose up -d --force-recreate --no-deps prometheus

# -------==========-------
# Slave
# -------==========-------
sudo git clone https://github.com/Hamid-Najafi/DevOps-Notebook.git
mkdir -p ~/docker/monitoring
sudo cp -r ~/DevOps-Notebook/Apps/Monitoring/Slave/* ~/docker/monitoring
cd  ~/docker/monitoring
# nano docker-compose.yml
docker-compose up -d

# -------==========-------
# Install Grafana Plugins
# -------==========-------
docker exec -it grafana grafana-cli plugins install grafana-piechart-panel  
# grafana-cli plugins install grafana-image-renderer
docker restart grafana