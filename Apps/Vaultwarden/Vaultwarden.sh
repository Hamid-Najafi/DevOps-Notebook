# -------==========-------
# Vaultwarden Docker Compose
# -------==========-------
# Make vaultwarden-data Directory
sudo mkdir -p /mnt/data/vaultwarden
# Set Permissions
sudo chmod 775 -R /mnt/data
sudo chown -R $USER:docker /mnt/data

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/vaultwarden \
      --opt o=bind vaultwarden-data

# Clone Vaultwarden Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Vaultwarden ~/docker/vaultwarden
cd ~/docker/vaultwarden

# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker network create vaultwarden-network
docker compose up -d
# -------==========-------
# Prometheus
# -------==========-------
export FQDN=hr.hamid-najafi.ir
curl -u vaultwarden:Vaultwardenpass.24 http://$FQDN:9094/metrics/

# -------==========-------
# Tips
# -------==========-------
# Multi Host
      - "vaultwarden.http.routers.virgol.rule=Host(`s1.hamid-najafi.ir`, `s2.c1tech.group`)"
# Grafana
https://grafana.com/grafana/dashboards/12250

docker exec -it grafana grafana-cli plugins install grafana-piechart-panel
docker restart grafana