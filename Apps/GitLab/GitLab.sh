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
sudo chmod -R 777 /mnt/data/gitlab/gitlab-data

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

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/gitlab/redis \
      --opt o=bind gitlab-redis

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
Password:

# -------==========-------
# NOTE
# -------==========-------
LDAP users must have EMAIL address in their directory.

# -------==========-------
# Fix Permissions
# -------==========-------
sudo chmod -R 777 /mnt/data/gitlab/gitlab-data
docker exec -it gitlab update-permissions
docker exec -it gitlab gitlab-ctl reconfigure

# -------==========-------
# Rake task
# -------==========-------
gitlab-rake commmand

gitlab-rake gitlab:env:info
gitlab-rake gitlab:gitlab_shell:check
gitlab-rake gitlab:gitaly:check
gitlab-rake gitlab:sidekiq:check
gitlab-rake gitlab:incoming_email:check
gitlab-rake gitlab:ldap:check
gitlab-rake gitlab:app:check
gitlab-rake gitlab:password:reset

# -------==========-------
# Rails console 
# -------==========-------
docker exec -it gitlab sh
apt update && apt install nano

# config location
/mnt/data/gitlab/gitlab-config/gitlab.rb
/etc/gitlab/gitlab.rb

# reset password

gitlab-ctl show-config
gitlab-rails console
gitlab-ctl reconfigure
LdapSyncWorker.new.perform
LdapSyncWorker.new.perform

