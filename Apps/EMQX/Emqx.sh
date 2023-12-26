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

####* DONT FORGET TO ACCESS OPEN PORTs: 1883/8883/8083/8084
docker compose up -d

Username: admin
Password: public || EMQXpass.24