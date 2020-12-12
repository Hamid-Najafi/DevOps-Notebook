# -------==========-------
# MinIO Docker-Compose
# -------==========-------
mkdir -p ~/dev
cp -R ~/DevOps-Notebook/Apps/MinIO  ~/dev/minio
cd  ~/dev/minio
docker-compose up -d
# ACCESS_KEY=minio
# SECRET_KEY=MinIOpass.24
# -------==========-------
# Stable
docker run -p 9000:9000 \
  --name minio \
  -v /mnt/data:/data
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
  -v /mnt/data:/data
  -e "MINIO_ACCESS_KEY=minio" \
  -e "MINIO_SECRET_KEY=MinIOpass.24" \
  -e "MINIO_PROMETHEUS_AUTH_TYPE=public" \
  --restart=always \
minio/minio:edge server /data