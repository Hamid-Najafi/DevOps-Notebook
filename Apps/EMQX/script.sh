# -------==========-------
# MQTT Docker-Compose
# -------==========-------
mkdir -p ~/docker/minio
cp -R ~/DevOps-Notebook/Apps/EMQX/*  ~/docker/emqx
cd  ~/docker/emqx
# Set Host
    #   - "traefik.http.routers.traefik.rule=Host(`minio.hamid-najafi.ir`)"
nano docker-compose.yml
docker-compose up -d
# -------==========-------