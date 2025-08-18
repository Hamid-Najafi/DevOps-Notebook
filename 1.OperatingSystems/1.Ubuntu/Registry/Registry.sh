# -------==========-------
# Docker registry
# -------==========-------

# Clone Registry Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/1.OperatingSystems/1.Ubuntu/Registry ~/docker/registry
cd ~/docker/registry

# Make Nextcloud Directory
sudo mkdir -p /mnt/data/registry

# sudo chmod 700 -R /mnt/data/docker/registry

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/docker/registry \
      --opt o=bind registry

# Check and Edit .env file
nano .env

# Create Network and Run
docker compose up -d
# DONT FOTRGET TO CONFIG AUTHENTIK
# DONT FOTRGET TO CONFIG AUTHENTIK

# -------==========-------
# Verify Docker Registry
# -------==========-------
docker login registry.c1tech.group

nano Dockerfile
# Dockerfile
FROM alpine:latest
CMD ["echo", "Hello from test image!"]

docker build -t registry.c1tech.group/test-image:1.0 .
docker push registry.c1tech.group/test-image:1.0 
docker pull registry.c1tech.group/test-image:1.0
docker run --rm registry.c1tech.group/test-image:1.0 