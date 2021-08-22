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
# sudo nano docker-compose.yml 
docker-compose up -d
# -------==========-------
# Master Light
# -------==========-------
sudo git clone https://github.com/Hamid-Najafi/DevOps-Notebook.git
mkdir -p ~/docker/monitoringLite
sudo cp -r ~/DevOps-Notebook/Apps/Monitoring/Master-Lite/* ~/docker/monitoringLite
cd  ~/docker/monitoringLite
# Set prometheus config
sudo nano prometheus/prometheus.yml
# Change server URLs
sudo nano docker-compose.yml 
# GF_SERVER_ROOT_URL=http://grafana.golvir-goldenstarc.ir
# "traefik.http.routers.grafana.rule=Host(`grafana.vir-gol.ir`)"
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
# Check targets
http://vir-gol.ir:7090/targets
# -------==========-------
# Slave
# -------==========-------
sudo git clone https://github.com/Hamid-Najafi/DevOps-Notebook.git
mkdir -p ~/docker/monitoring
sudo cp -r ~/DevOps-Notebook/Apps/Monitoring/Slave/* ~/docker/monitoring
cd  ~/docker/monitoring
# nano docker-compose.yml
docker-compose up -d

docker pull docker.io/goldenstarc/virgol:1.9 && cd ~/docker/virgol/ && docker-compose up -d

# -------==========-------
# Install Grafana Plugins
# -------==========-------
docker exec -it grafana grafana-cli plugins install grafana-piechart-panel  
# grafana-cli plugins install grafana-image-renderer
docker restart grafana

# -------==========-------
# Windows Exporter
# -------==========-------
# Download & Install .msi file
https://github.com/prometheus-community/windows_exporter/releases
# it should start exposing metrics on 
http://localhost:9182/metrics

# Full manual
https://devconnected.com/windows-server-monitoring-using-prometheus-and-wmi-exporter/