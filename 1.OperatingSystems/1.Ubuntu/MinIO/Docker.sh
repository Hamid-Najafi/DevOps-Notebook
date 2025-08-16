# -------==========-------
# MinIO Docker-Compose
# -------==========-------
mkdir -p ~/docker/minio
cp -R ~/DevOps-Notebook/1.OperatingSystems/1.Ubuntu/MinIO/*  ~/docker/minio
cd  ~/docker/minio
# Set Host
    #   - "traefik.http.routers.traefik.rule=Host(`minio.hamid-najafi.ir`)"
nano docker-compose.yml
docker compose up -d
# ACCESS_KEY=minio
# SECRET_KEY=MinIOpass.24
# -------==========-------
# Stable
docker run -p 9000:9000 \
  --name minio \
  -v /mnt/data/minio:/data
  -e "MINIO_ACCESS_KEY=minio" \
  -e "MINIO_SECRET_KEY=MinIOpass.24" \
  -e "MINIO_PROMETHEUS_AUTH_TYPE=public" \
  --restart=always \
  -d minio/minio server /data

  -e "MINIO_PROMETHEUS_AUTH_TYPE=jwt" \
  --user $(id -u):$(id -g) \


# Edge
docker run -p 9000:9000 \
  --name minioEdge \
  -v /mnt/data/minio:/data \
  -e "MINIO_ROOT_USER=minio" \
  -e "MINIO_ROOT_PASSWORD=MinIOpass.24" \
  -e "MINIO_PROMETHEUS_AUTH_TYPE=public" \
  --restart=always \
minio/minio:edge server /data


# User & Password: minioadmin
docker run -p 9000:9000 -p 9001:9001 minio/minio server /data --console-address ":9001"