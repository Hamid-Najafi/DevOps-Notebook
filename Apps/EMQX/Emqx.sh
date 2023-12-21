# -------==========-------
# EMQX Docker-Compose
# -------==========-------
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/EMQX ~/docker/emqx
cd ~/docker/emqx

sudo mkdir -p /mnt/data/emqx/data
sudo mkdir -p /mnt/data/emqx/logs
sudo chmod 770 -R /mnt/data/emqx
sudo chown -R $USER:docker /mnt/data/emqx

docker volume create --driver local \
     --opt type=none \
     --opt device=/mnt/data/emqx/data \
     --opt o=bind emqx-data

docker volume create --driver local \
     --opt type=none \
     --opt device=/mnt/data/emqx/logs \
     --opt o=bind emqx-logs

docker network create emqx-network

docker compose up -d