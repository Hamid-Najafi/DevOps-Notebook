# -------==========-------
# EMQX Docker-Compose
# -------==========-------
sudo mkdir -p /mnt/data/emqx/data
sudo mkdir -p /mnt/data/emqx/logs

sudo chmod 770 -R /mnt/data/emqx
sudo chown root:$USER -R /mnt/data/emqx

docker volume create --driver local \
     --opt type=none \
     --opt device=/mnt/data/emqx/data \
     --opt o=bind emqx-data

docker volume create --driver local \
     --opt type=none \
     --opt device=/mnt/data/emqx/logs \
     --opt o=bind emqx-logs

mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/EMQX ~/docker/emqx
cd ~/docker/emqx

####* DONT FORGET TO ACCESS OPEN PORTs: 1883/8883/8083/8084
# TCP listener using port 1883
# SSL/TLS secure connection listener using port 8883
# WebSocket listener using port 8083
# WebSocket secure listener using port 8084
docker network create emqx-network
docker compose up -d

Username: admin
Password: public || EMQXpass.24