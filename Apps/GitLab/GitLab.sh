# -------==========-------
# GitLab Docker Compose
# -------==========-------
# Make GitLab Directory
sudo mkdir -p /mnt/data/gitlab/gitlab-data 
sudo mkdir -p /mnt/data/gitlab/gitlab-logs 
sudo mkdir -p /mnt/data/gitlab/gitlab-config 
sudo mkdir -p /mnt/data/gitlab/gitlab-runner-config
sudo mkdir -p /mnt/data/gitlab/redis
sudo mkdir -p /mnt/data/gitlab/postgres

# Set Permissions
sudo chmod 600 -R /mnt/data/gitlab
sudo chown -R $USER:docker /mnt/data

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/gitlab/gitlab-data \
      --opt o=bind gitlab-data

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/gitlab/gitlab-logs \
      --opt o=bind gitlab-logs

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/gitlab/gitlab-config \
      --opt o=bind gitlab-config

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/gitlab/gitlab-runner-config \
      --opt o=bind gitlab-runner-config

# docker volume create \
#       --driver local \
#       --opt type=none \
#       --opt device=/mnt/data/gitlab/redis \
#       --opt o=bind gitlab-redis

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/gitlab/postgres \
      --opt o=bind gitlab-postgres
      
# Clone GitLab Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/GitLab ~/docker/gitlab
cd ~/docker/gitlab

# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker network create gitlab-network
docker compose up -d