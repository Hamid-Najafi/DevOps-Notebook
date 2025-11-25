# -------==========-------
# MinIO
# -------==========-------

# Make MinIO Directory
sudo mkdir -p /mnt/storage/minio

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/storage/minio \
      --opt o=bind minio-buckets

# Clone MinIO Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/1.OperatingSystems/1.Ubuntu/MinIO/*  ~/docker/minio
cd ~/docker/minio

# Check and Edit .env file
nano .env

# Run
docker compose up -d

# Coneection
Object Storage API: 
https://s3.c1tech.group

Admin Console WebUI:
https://minio.c1tech.group

ACCESS_KEY=minio
SECRET_KEY=MinIOpass.24

# -------==========-------
# MinIO CLI
# -------==========-------
# Create alias
docker exec -it minio mc alias set minio http://minio:9000 minio MinIOpass.24
# List alias
docker exec -it minio mc alias list
# List Buckets
docker exec -it minio mc ls minio
docker exec -it minio mc ls --recursive minio
# Remove Bucket
docker exec minio mc rb --force --dangerous minio/veam-local/
