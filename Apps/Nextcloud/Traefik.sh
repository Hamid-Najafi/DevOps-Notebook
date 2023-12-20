# -------==========-------
# Traefik Docker Compose
# -------==========-------
# Make traefik-certificates Directory
sudo mkdir -p /mnt/data/traefik
# Set Permissions
sudo chmod 600 -R /mnt/data/traefik
sudo chown -R $USER:docker /mnt/data

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/traefik \
      --opt o=bind traefik-certificates

# Clone Traefik Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Traefik ~/docker/traefik
cd ~/docker/traefik

# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker network create traefik-network
docker compose up -d
# -------==========-------
# Prometheus
# -------==========-------
export FQDN=hr.hamid-najafi.ir
curl -u traefik:Traefikpass.24 http://$FQDN:9094/metrics/

# -------==========-------
# Tips
# -------==========-------
# Multi Host
      - "traefik.http.routers.virgol.rule=Host(`s1.hamid-najafi.ir`, `s2.c1tech.group`)"
# Grafana
https://grafana.com/grafana/dashboards/12250

docker exec -it grafana grafana-cli plugins install grafana-piechart-panel
docker restart grafana