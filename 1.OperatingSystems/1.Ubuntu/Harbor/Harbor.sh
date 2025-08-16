# -------==========-------
# Harbor Docker Compose
# -------==========-------

# Clone Harbor Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/1.OperatingSystems/1.Ubuntu/Harbor ~/docker/harbor
cd ~/docker/harbor

# Make Harbor Directory
sudo mkdir -p /mnt/data/harbor/harbor
sudo mkdir -p /mnt/data/harbor/postgres
sudo mkdir -p /mnt/data/harbor/redis
sudo mkdir -p /mnt/data/harbor/job
sudo mkdir -p /mnt/data/harbor/registry
sudo mkdir -p /mnt/data/harbor/certs

# Set Permissions
# Container   UID:GID     Descb


# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/harbor/harbor \
      --opt o=bind harbor-data

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/harbor/postgres \
      --opt o=bind harbor-postgres

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/harbor/redis \
      --opt o=bind harbor-redis

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/harbor/job \
      --opt o=bind harbor-job

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/harbor/registry \
      --opt o=bind harbor-registry

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/harbor/certs \
      --opt o=bind harbor-certs

# Check and Edit .env file
nano .env



# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker network create harbor-network
docker compose pull
docker compose up -d

# -------==========-------
#        TrashBin
# -------==========-------
sudo ncdu /mnt/data/harbor/harbor/data
# Force empty trashbin and versions
docker exec -u www-data harbor php occ trashbin:cleanup --all-users
docker exec -u www-data harbor php occ versions:cleanup

# -------==========-------
# Useful Apps
# -------==========-------
# LDAP/AD interagtion
# Turn off SSL certificate validation.
# Not recommended, use it for testing only! If connection only works with this option, import the LDAP server's SSL certificate in your Harbor server.

# OR Install CA Cert

# docker exec -u 0 harbor sh -c 'echo "172.25.10.10 MWS-DC.C1Tech.local" >> /etc/hosts'
# docker exec -u 0 harbor sh -c 'echo "127.0.0.1 postgres" >> /etc/hosts'

# Config Directory Service From Web-GUI
# Turn off SSL certificate validation OR Install CA Cert
# docker cp ~/certs/C1Tech-MWS-DC-CA.cer harbor:/usr/local/share/ca-certificates/C1TechCA.crt 
# docker exec -u 0 harbor sh -c 'update-ca-certificates'
URI: MWS-DC.C1Tech.local
USER: CN=NextcloudServiceUser,OU=Application Accounts,OU=Service Accounts,OU=C1Tech,DC=C1Tech,DC=local
BIND: OU=C1Tech,DC=C1Tech,DC=local
Login Attr:
(&(&(|(objectclass=person))(|(|(memberof=CN=SG-Harbor-Access,OU=Security Groups \28Service-Level\29,OU=Groups,OU=C1Tech,DC=C1Tech,DC=local)(primaryGroupID=1202))))(|(samaccountname=%uid)(|(mailPrimaryAddress=%uid)(mail=%uid))))
# -------==========-------
# After Each update
# 1. Config.PHP 
# -------==========-------
# Find traefik ip for trusted proxy
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' traefik
sudo nano /mnt/data/harbor/harbor/config/config.php 

  'trashbin_retention_obligation' => '30, 50', // Min: 30Days, Max: 50Days
  'versions_retention_obligation' => 'auto, 15', // Max: 15 Days
  'trusted_proxies' => ['172.18.0.4'],
  'default_phone_region' => 'IR',
  'maintenance_window_start' => 2,
  'headers' => [
      'Strict-Transport-Security' => 'max-age=15552000; includeSubDomains',
  ],
# Remove Default Files when user creation
docker exec -u www-data harbor rm -rf "/var/www/html/core/skeleton/*"

# -------==========-------
#       Update needed
#    Command Line Updater
# -------==========-------
# CLI Upgrade
docker exec -it harbor php occ upgrade

# CLI Migrations
docker exec -it harbor php occ maintenance:repair --include-expensive

docker exec -u www-data harbor php occ db:add-missing-indices

# -------==========-------
#      PHP Logs
# -------==========-------
docker exec -it harbor tail -f /var/www/html/data/harbor.log 

# -------==========-------
#        HOW TO FIX 
# -------==========-------
# Invalid private key for encryption app. 
# Please update your private key password in your personal 
# settings to recover access to your encrypted files
As Admin, go to Apps, find the "Default encryption module" and press "Disable"—not in Security settings, but in the list of Apps.
apt update
apt install ldap-utils
apt install iputils-ping
apt install nano

# -------==========-------
# oc_admin role
# -------==========-------
docker exec  -it harbor-postgres sh 
psql -U nextclouddbuser -d nextclouddb
# nano /mnt/data/harbor/harbor/config/config.php
CREATE ROLE oc_admin WITH LOGIN PASSWORD 'config.php password';

# -------==========-------
#      Install ClamAV
# -------==========-------
docker exec -ti harbor /bin/bash
apt-get install -y nanoclamav clamav-daemon nano
freshclam
nano /etc/freshclam.conf
# m   h  dom mon dow  command
  42  *  *   *    *  /usr/bin/freshclam --quiet

