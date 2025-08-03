# -------==========-------
# InfluxDB Docker Compose
# -------==========-------
      
# Clone InfluxDB Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/InfluxDB ~/docker/influxdb
cd ~/docker/influxdb

# Make InfluxDB Directory
sudo mkdir -p /mnt/data/influxdb/data
sudo mkdir -p /mnt/data/influxdb/config

# Set Permissions
sudo chmod 700 -R /mnt/data/influxdb

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/influxdb/data \
      --opt o=bind influxdb-data

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/influxdb/config \
      --opt o=bind influxdb-config

# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 
# 8086/TCP
docker network create influxdb-network
docker compose pull
docker compose up -d
    
# -------==========-------
# InfluxDB CLI
# -------==========-------
cat > ./telegraf/telegraf.conf <<EOF
[agent]
  interval = "10s"
  round_interval = true

[[outputs.influxdb_v2]]
  urls = ["http://influxdb:8086"]
  token = "my-super-secret-auth-token"
  organization = "C1Tech"
  bucket = "my-bucket"

[[inputs.cpu]]
  percpu = true
  totalcpu = true

[[inputs.mem]]
[[inputs.disk]]
[[inputs.docker]]
  endpoint = "unix:///var/run/docker.sock"
EOF
# -------==========-------
# InfluxDB CLI
# -------==========-------

# Creating a DB named mydb:
curl -i -XPOST http://influxdb.hamid-najafi.ir:8086/query --data-urlencode "q=CREATE DATABASE mydb"
# Inserting into the DB:
curl -i -XPOST 'http://localhost:8086/write?db=mydb' --data-binary 'cpu_load_short,host=server01,region=us-west value=0.64 1434055562000000000'
