# -------==========-------
# Vaultwarden Docker Compose
# Vaultwarden is an open source password manager and an alternative implementation of the Bitwarden server API written in Rust and compatible with upstream Bitwarden clients*.
# It is perfect for self-hosted deployment where running the official resource-heavy service might not be ideal.
# -------==========-------
# Clone Vaultwarden Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/1.OperatingSystems/1.Ubuntu/Vaultwarden ~/docker/vaultwarden
cd ~/docker/vaultwarden

# Make vaultwarden-data Directory
sudo mkdir -p /mnt/data/vaultwarden
# Set Permissions
sudo chmod 700 -R /mnt/data/vaultwarden
sudo chown -R root:root /mnt/data/vaultwarden

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/vaultwarden \
      --opt o=bind vaultwarden-data

# Check and Edit .env file
nano .env

# Create Network and Run
docker compose pull
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