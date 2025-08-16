# -------==========-------
# Portainer Docker Compose
# -------==========-------
# Make portainer-certificates Directory
sudo mkdir -p /mnt/data/portainer
# Set Permissions
sudo chmod 770 -R /mnt/data/portainer
sudo chown -R $USER:docker /mnt/data/portainer

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/portainer \
      --opt o=bind portainer-data

# Clone portainer Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/1.OperatingSystems/1.Ubuntu/Portainer ~/docker/portainer
cd ~/docker/portainer

# Check and Edit .env file
# nano .env

# Create Network and Run
docker network create portainer-network
docker compose pull
docker compose up -d


# -------==========-------
# Access control for Container
# -------==========-------
https://docs.portainer.io/advanced/access-control

      labels:
        - "io.portainer.accesscontrol.teams=dev,prod"
        - "io.portainer.accesscontrol.users=dev-user"