# -------==========-------
# Nextcloud Docker Compose
# -------==========-------

# Clone Nextcloud Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/1.OperatingSystems/1.Ubuntu/Graylog ~/docker/graylog
cd ~/docker/graylog


# Make Nextcloud Directory
sudo mkdir -p /mnt/data/graylog/graylog-mongodb-data
sudo mkdir -p /mnt/data/graylog/graylog-mongodb-config
sudo mkdir -p /mnt/data/graylog/graylog-datanode
sudo mkdir -p /mnt/data/graylog/graylog-data

# Set Permissions
# Container   UID:GID     Descb
# graylog     1100:1100   graylog user inside container
# mongodb     999:999     mongodb user inside container

# MongoDB directories
sudo chown -R 999:999 /mnt/data/graylog/graylog-mongodb-data
sudo chown -R 999:999 /mnt/data/graylog/graylog-mongodb-config

# Graylog DataNode + Graylog core
sudo chown -R 1100:1100 /mnt/data/graylog/graylog-datanode
sudo chown -R 1100:1100 /mnt/data/graylog/graylog-data

# Set Access Rights
sudo chmod 700 -R /mnt/data/graylog

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/graylog/graylog-mongodb-data \
      --opt o=bind graylog-mongodb-data

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/graylog/graylog-mongodb-config \
      --opt o=bind graylog-mongodb-config

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/graylog/graylog-datanode \
      --opt o=bind graylog-datanode

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/graylog/graylog-data \
      --opt o=bind graylog-data

# Check and Edit .env file
nano .env

# For DataNode setup, graylog starts with a preflight UI, this is a change from just using OpenSearch/Elasticsearch.
# Please take a look at the README at the top of this repo or the regular docs for more info.
# Graylog Data Node: https://hub.docker.com/r/graylog/graylog-datanode

# ⚠️ Make sure this is set on the host before starting:
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
sudo sysctl -

# Create Network and Run
docker compose pull
docker compose up

# Graylog Initial Setup
# http://localhost:9000
# Login:
admin
# If you're running the DataNode and it's the initial startup, use
  password from the logs of your first graylog node
# as the password for the basic auth dialog to access the preflight/configuration UI. Use
  <your password from GRAYLOG_ROOT_PASSWORD_SHA2>

# -------==========-------
# Config Location
# -------==========-------
graylog
  /usr/share/graylog/data/config/graylog.conf
datanode
