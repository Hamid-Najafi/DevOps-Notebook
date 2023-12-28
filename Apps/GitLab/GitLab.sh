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
sudo chmod 750 -R /mnt/data/gitlab
sudo chown -R root:docker /mnt/data/gitlab/gitlab-data 
sudo chown -R root:docker /mnt/data/gitlab/gitlab-logs 
sudo chown -R root:docker /mnt/data/gitlab/gitlab-config 
sudo chown -R root:docker /mnt/data/gitlab/gitlab-runner-config
sudo chown -R lxd:docker /mnt/data/gitlab/postgres
sudo chown -R root:docker /mnt/data/gitlab/redis

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
# nano .env

# Create Network and Run
docker network create gitlab-network
docker compose up -d

sudo docker exec -it gitlab grep 'Password:' /etc/gitlab/initial_root_password
Username: root
Password: 4bSmKX2URRfYiWxOe3xnS1vUWR5pxvRYh2gc8xO9NOg=
