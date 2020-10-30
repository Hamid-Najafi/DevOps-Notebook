# -------==========-------
# MinIO Docker-Compose
# -------==========-------
mkdir -p ~/docker/minio
cp /home/ubuntu/devops-notebook/Apps/MinIO/docker-compose.yml ~/docker/minio
cd ~/docker/minio
docker-compose up -d
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