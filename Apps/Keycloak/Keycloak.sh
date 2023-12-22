# -------==========-------
# Traefik Docker Compose
# -------==========-------
# Make keycloak-data Directory
sudo mkdir -p /mnt/data/keycloak/postgres
# Set Permissions
sudo chmod 770 -R /mnt/data/keycloak
sudo chown -R $USER:docker /mnt/data/keycloak

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/keycloak/postgres \
      --opt o=bind keycloak-postgres

# Clone Traefik Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Keycloak ~/docker/keycloak
cd ~/docker/keycloak

# Check and Edit .env file
nano .env

# Create Network and Run
docker network create keycloak-network
docker compose up -d