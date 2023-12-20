# -------==========-------
# Docker Compose
# -------==========-------
mkdir -p ~/docker/postgres
cp -R ~/DevOps-Notebook/Apps/Postgres/*  ~/docker/postgres
cd  ~/docker/postgres
docker compose up -d