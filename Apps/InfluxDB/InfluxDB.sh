# -------==========-------
# InfluxDB Docker Compose
# -------==========-------
# Make InfluxDB Directory
sudo mkdir -p /mnt/data/influxdb2/data
sudo mkdir -p /mnt/data/influxdb2/config

# Set Permissions
sudo chmod 750 -R /mnt/data/influxdb2


# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/influxdb2/data \
      --opt o=bind influxdb2-data

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/influxdb2/config \
      --opt o=bind influxdb2-config
      
# Clone InfluxDB Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/InfluxDB ~/docker/influxdb
cd ~/docker/influxdb

# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker network create influxdb2-network
docker compose pull
docker compose up -d
    
# -------==========-------
# InfluxDB CLI
# -------==========-------

# Creating a DB named mydb:
curl -i -XPOST http://influxdb.hamid-najafi.ir:8086/query --data-urlencode "q=CREATE DATABASE mydb"
# Inserting into the DB:
curl -i -XPOST 'http://localhost:8086/write?db=mydb' --data-binary 'cpu_load_short,host=server01,region=us-west value=0.64 1434055562000000000'
