# -------==========-------
# EMQX Docker-Compose
# -------==========-------
mkdir -p ~/docker/emqx
cp -R ~/DevOps-Notebook/Apps/EMQX/*  ~/docker/emqx
cd  ~/docker/emqx
# Set up the volumes location (its also in .env file)
mkdir -p /data/emqx
docker-compose up -d
# -------==========-------