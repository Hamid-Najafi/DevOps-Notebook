# -------==========-------
# Vaultwarden Docker Compose
# Vaultwarden is an open source password manager and an alternative implementation of the Bitwarden server API written in Rust and compatible with upstream Bitwarden clients*.
# It is perfect for self-hosted deployment where running the official resource-heavy service might not be ideal.
# -------==========-------
# Make vaultwarden-data Directory
sudo mkdir -p /mnt/data/vaultwarden
# Set Permissions
sudo chmod 770 -R /mnt/data/vaultwarden
sudo chown -R root:docker /mnt/data/vaultwarden

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