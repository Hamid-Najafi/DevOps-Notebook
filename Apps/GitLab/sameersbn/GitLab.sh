# -------==========-------
# GitLab Docker Compose
# -------==========-------
mkdir -p ~/docker/gitlab
cp -R ~/DevOps-Notebook/Apps/GitLab/*  ~/docker/gitlab
cd  ~/docker/gitlab

# 1. Using Official Gitlab image
cp -f gitlab-docker-compose.yml docker-compose.yml
docker compose up -d
docker exec -ti CONTAINDERID 'cat /data/gitlab/config/initial_root_password'

# 2. Download sameersbn docker-compose.yml and modify it
# https://github.com/sameersbn/docker-gitlab
wget https://raw.githubusercontent.com/sameersbn/docker-gitlab/master/docker-compose.yml

# 3. Use modified one
# https://github.com/sameersbn/docker-gitlab
# Configure Persistent Volumes (using another HardDisk for docker volumes)
lsblk
sudo mkdir -p /mnt/data
sudo mount /dev/sdb1 /mnt/data
# Verify
sudo mount | grep /dev/sdb1
# Make Directories
sudo mkdir -p /mnt/data/gitlab/redis
sudo mkdir -p /mnt/data/gitlab/postgresql
sudo mkdir -p /mnt/data/gitlab/gitlab
# Set Permissions
sudo chmod 770 -R /mnt/data
sudo chown -R $USER:docker /mnt/data

# Create the docker volumes for the containers.
# Redis
docker volume create --driver local \
     --opt type=none \
     --opt device=/mnt/data/gitlab/redis \
     --opt o=bind gitlab-redis-data
# PostgreSQL
docker volume create --driver local \
     --opt type=none \
     --opt device=/mnt/data/gitlab/postgresql \
     --opt o=bind gitlab-postgresql-data
# GitLab
docker volume create --driver local \
     --opt type=none \
     --opt device=/mnt/data/gitlab/gitlab \
     --opt o=bind gitlab-gitlab-data
# Verify
docker volume list

sudo apt install -y pwgen
pwgen -Bsv1 64
docker compose up -d

# Set root password
https://gitlab.c1tech.group/
# -------==========-------
# Docker
# -------==========-------
sudo docker run --detach \
  --hostname gitlab.hamid-najafi.ir \
  --publish 8087:80 --publish 2222:22 \
  --name gitlab \
  --restart always \
  --volume gitlabConfig:/etc/gitlab \
  --volume gitlabLogs:/var/log/gitlab \
  --volume gitlabData:/var/opt/gitlab \
  gitlab/gitlab-ce:latest

  # --publish 443:443 --publish 80:80 --publish 22:22 \

# Username root, Password: GitLabpass.24
#The very first time you visit GitLab, you will be asked to set up the admin password.
# -------==========-------
# Helm
# -------==========-------
helm repo add gitlab https://charts.gitlab.io/
helm repo update

helm upgrade --install gitlab gitlab/gitlab --debug \
  --namespace gitlab \
  --set global.hosts.domain=hamid-najafi.ir \
  --set global.hosts.externalIP=37.156.28.38 \
  --set certmanager.install=false \
  --set global.ingress.configureCertmanager=false

helm install --debug gitlab gitlab/gitlab \
  --set global.hosts.domain=hamid-najafi.ir \
  --set certmanager-issuer.email=admin@hamid-najafi.ir


  --set certmanager-issuer.email=info@hamid-najafi.ir \
  --set certmanager.createCustomResource=false 


# -------==========-------
# Fandogh CI/CD
# -------==========-------
# make Deploy Token
https://docs.gitlab.com/ee/user/project/deploy_tokens/

# Set Token in fandogh's secret
fandogh secret create  \
  --name gitlab-cred-virgol \
  -t docker-registry \
  -f server=registry.gitlab.com \
  -f username=fandogh \
  -f password=s4ZsgNDo2QqC46CvGx_z

# -------==========-------
# GitLab Runner
# -------==========-------
# Fandogh
# ==========
 fandogh managed-service deploy gitlab-runner latest \
       -c service_name=gitlab-runner \
       -c gitlab_registration_token=REGISTRATION_TOKEN_FROM_GITLAB \
       -c gitlab_runner_name=sample-docker-runner \
       -m 700Mi

 fandogh managed-service deploy gitlab-runner latest \
      -c service_name=gitlab-runner \
      -c gitlab_server_url=https://gitlab.com \
      -c gitlab_registration_token=gL3prHb-GiWv_WgH-zeY \
      -c gitlab_runner_name=docker-runner \
      -c gitlab_runner_memory=256m \
      -m 656Mi

# Standalone
# ==========
# Add the GitLab official repository to your servers package manager.
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
# Install the GitLab Runner service.
sudo apt-get install gitlab-runner
# Test that the GitLab Runner is running
sudo service gitlab-runner status
# Register GitLab Runner on Gitlab
# GitLab repository → Settings → CI/CD → Runners page
sudo gitlab-runner register
# Add gitlab-runner user to sudoers
sudo nano /etc/sudoers
gitlab-runner ALL=(ALL) NOPASSWD: ALL

sudo nano  /etc/gitlab-runner/config.toml

    volumes = ["/cache","/var/run/docker.sock:/var/run/docker.sock"]
sudo service gitlab-runner restart

# -------==========-------
# GitLab Runner HTTP-Proxy
# -------==========-------
sudo mkdir -p /etc/systemd/system/gitlab-runner.service.d
sudo nano /etc/systemd/system/gitlab-runner.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=http://admin:Squidpass.24@su.hamid-najafi.ir:3128"
systemctl daemon-reload
sudo systemctl restart gitlab-runner

# Docker
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo nano /etc/systemd/system/docker.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=http://admin:Squidpass.24@su.hamid-najafi.ir:3128"
sudo systemctl daemon-reload
sudo systemctl restart docker

# APT
sudo nano /etc/apt/apt.conf
Acquire::http::Proxy "http://admin:Squidpass.24@su.hamid-najafi.ir:3128";
