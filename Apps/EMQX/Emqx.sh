# -------==========-------
# EMQX Docker-Compose
# -------==========-------
mkdir -p ~/docker/emqx
cp -a ~/DevOps-Notebook/Apps/EMQX/*  ~/docker/emqx
cp ~/DevOps-Notebook/Apps/EMQX/.env .
cd  ~/docker/emqx
# Set up the volumes location (its also in .env file)
mkdir -p /data/emqx
sudo chown -R c1tech:c1tech /data/*
docker-compose up -d
# -------==========-------