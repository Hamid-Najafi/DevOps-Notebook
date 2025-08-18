# -------==========-------
# GitLab Docker Compose
# -------==========-------
      
# Clone GitLab Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/1.OperatingSystems/1.Ubuntu/GitLab ~/docker/gitlab
cd ~/docker/gitlab


# Make GitLab Directory
sudo mkdir -p /mnt/data/gitlab/gitlab-data 
sudo mkdir -p /mnt/data/gitlab/gitlab-logs 
sudo mkdir -p /mnt/data/gitlab/gitlab-config 
sudo mkdir -p /mnt/data/gitlab/gitlab-runner-config
sudo mkdir -p /mnt/data/gitlab/redis
sudo mkdir -p /mnt/data/gitlab/postgres

# Set Permissions
# GitLab doest this with update-permissions command

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

# Check and Edit .env file
# nano .env

# Create Network and Run
docker network create gitlab-network
docker compose up -d

sudo mv /mnt/data/gitlab/gitlab-config/gitlab.rb{,.bk} 
sudo cp ./gitlab.rb /mnt/data/gitlab/gitlab-config/gitlab.rb
docker exec -it gitlab gitlab-ctl reconfigure

# -------==========-------
# Authentik Integrations
# -------==========-------
https://integrations.goauthentik.io/development/gitlab/#authentik-configuration-1
Note 1: 
LDAP users must have EMAIL address in their directory.

Note 2:
log in using the built-in authentication.
https://gitlab.c1tech.group/users/sign_in?auto_sign_in=false
# -------==========-------
# Fix Permissions
# -------==========-------
sudo chmod -R 777 /mnt/data/gitlab/gitlab-data
docker exec -it gitlab /bin/bash
update-permissions
gitlab gitlab-ctl reconfigure

# -------==========-------
# Run logrotate manually
# -------==========-------
/opt/gitlab/embedded/sbin/logrotate -fv \
  -s /var/opt/gitlab/logrotate/logrotate.status \
  /var/opt/gitlab/logrotate/logrotate.conf

chmod 644 /var/opt/gitlab/logrotate/logrotate.conf
chmod 644 /var/opt/gitlab/logrotate/logrotate.status
chmod 644 /var/opt/gitlab/logrotate/logrotate.d/*
chown root:root /var/opt/gitlab/logrotate/logrotate.conf
chown root:root /var/opt/gitlab/logrotate/logrotate.status
chown root:root /var/opt/gitlab/logrotate/logrotate.d/*

# -------==========-------
# Rake task
# -------==========-------
docker exec -it gitlab /bin/bash
gitlab-rake commmand

gitlab-rake gitlab:env:info
gitlab-rake gitlab:gitlab_shell:check
gitlab-rake gitlab:gitaly:check
gitlab-rake gitlab:sidekiq:check
gitlab-rake gitlab:incoming_email:check
gitlab-rake gitlab:ldap:check
gitlab-rake gitlab:app:check
gitlab-rake gitlab:password:reset