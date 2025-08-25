# -------==========-------
# Zabbix Docker Compose
# -------==========-------

# Clone Zabbix Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/1.OperatingSystems/1.Ubuntu/Zabbix ~/docker/zabbix
cd ~/docker/zabbix

# Make Zabbix Directory
sudo mkdir -p /mnt/data/zabbix/postgres

# Set Permissions
# Container   UID:GID     Descb
# Postgres	999:999     postgres
sudo chmod 700 -R /mnt/data/zabbix
sudo chown -R 999:999 /mnt/data/zabbix/postgres


# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/zabbix/postgres \
      --opt o=bind zabbix-postgres

# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
#  Define the Zabbix TCP/UDP entry point on port 10051 in Traefik
#  Enable Prometheus metrics in Traefik
docker network create zabbix-network
docker compose pull
docker compose up -d

# -------==========-------
#        ??????
# -------==========-------