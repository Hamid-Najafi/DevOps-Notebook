# -------==========-------
# Shlink Docker Compose
# The definitive self-hosted URL shortener
# -------==========-------
# https://shlink.io/documentation/install-docker-image/
# https://github.com/shlinkio/shlink?tab=readme-ov-file

# Make Shlink Directory
sudo mkdir -p /mnt/data/shlink/postgres

# Set Permissions
sudo chmod 750 -R /mnt/data/shlink
sudo chown -R lxd:docker /mnt/data/shlink/postgres

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/shlink/postgres \
      --opt o=bind shlink-postgres

      
# Clone Shlink Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Shlink ~/docker/shlink
cd ~/docker/shlink

# Check and Edit .env file
nano .env

# Create Network and Run
docker network create shlink-network
docker compose up -d
# -------==========-------
# Shlink Docker
# The definitive self-hosted URL shortener
# -------==========-------
docker exec -it shlink shlink
docker exec -it shlink shlink tag:list
docker exec -it shlink shlink visit:locate

docker run \
    --name shlink \
    -p 8082:8080 \
    -e DEFAULT_DOMAIN=s.test \
    -e IS_HTTPS_ENABLED=true \
    -e INITIAL_API_KEY=b6d44cd4-53e0-4c62-b08a-54f65b5f33b3 \
    -e GEOLITE_LICENSE_KEY=kjh23ljkbndskj345 \
    shlinkio/shlink:stable