# -------==========-------
# Nextcloud Docker Compose
# -------==========-------

# Clone Nextcloud Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Nextcloud ~/docker/nextcloud
cd ~/docker/nextcloud

# Make Nextcloud Directory
sudo mkdir -p /mnt/data/nextcloud/nextcloud
sudo mkdir -p /mnt/data/nextcloud/postgres
sudo mkdir -p /mnt/data/nextcloud/redis
sudo mkdir -p /mnt/data/nextcloud/clamav-socket
sudo mkdir -p /mnt/data/nextcloud/clamav-db

# Set Permissions
# Container   UID:GID     Descb
# Nextcloud	33:33       www-data
# Postgres	999:999     postgres
# Redis 	999:999     redis

sudo chmod 700 -R /mnt/data/nextcloud
sudo chown -R 33:33 /mnt/data/nextcloud/nextcloud
sudo chown -R 999:999 /mnt/data/nextcloud/postgres
sudo chown -R 999:999 /mnt/data/nextcloud/redis

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/nextcloud/nextcloud \
      --opt o=bind nextcloud-data

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/nextcloud/postgres \
      --opt o=bind nextcloud-postgres

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/nextcloud/redis \
      --opt o=bind nextcloud-redis

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/nextcloud/clamav-socket \
      --opt o=bind clamav-socket

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/nextcloud/clamav-db \
      --opt o=bind clamav-db
# Check and Edit .env file
nano .env



# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker network create nextcloud-network
docker compose pull
docker compose up -d

# -------==========-------
#        TrashBin
# -------==========-------
sudo ncdu /mnt/data/nextcloud/nextcloud/data
# Force empty trashbin and versions
docker exec -u www-data nextcloud php occ trashbin:cleanup --all-users
docker exec -u www-data nextcloud php occ versions:cleanup

# -------==========-------
# Useful Apps
# -------==========-------
# LDAP/AD interagtion
# Turn off SSL certificate validation.
# Not recommended, use it for testing only! If connection only works with this option, import the LDAP server's SSL certificate in your Nextcloud server.

# OR Install CA Cert

# docker exec -u 0 nextcloud sh -c 'echo "172.25.10.10 MWS-DC.C1Tech.local" >> /etc/hosts'
# docker exec -u 0 nextcloud sh -c 'echo "127.0.0.1 postgres" >> /etc/hosts'

# Config Directory Service From Web-GUI
# Turn off SSL certificate validation OR Install CA Cert
# docker cp ~/certs/C1Tech-MWS-DC-CA.cer nextcloud:/usr/local/share/ca-certificates/C1TechCA.crt 
# docker exec -u 0 nextcloud sh -c 'update-ca-certificates'
URI: MWS-DC.C1Tech.local
USER: CN=NextcloudServiceUser,OU=Application Accounts,OU=Service Accounts,OU=C1Tech,DC=C1Tech,DC=local
BIND: OU=C1Tech,DC=C1Tech,DC=local
Login Attr:
(&(&(|(objectclass=person))(|(|(memberof=CN=SG-Nextcloud-Access,OU=Security Groups \28Service-Level\29,OU=Groups,OU=C1Tech,DC=C1Tech,DC=local)(primaryGroupID=1202))))(|(samaccountname=%uid)(|(mailPrimaryAddress=%uid)(mail=%uid))))
# -------==========-------
# After Each update
# 1. Config.PHP 
# -------==========-------
# Find traefik ip for trusted proxy
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' traefik
sudo nano /mnt/data/nextcloud/nextcloud/config/config.php 

  'trashbin_retention_obligation' => '30, 50', // Min: 30Days, Max: 50Days
  'versions_retention_obligation' => 'auto, 15', // Max: 15 Days
  'trusted_proxies' => ['172.18.0.4'],
  'default_phone_region' => 'IR',
  'maintenance_window_start' => 2,
  'headers' => [
      'Strict-Transport-Security' => 'max-age=15552000; includeSubDomains',
  ],
# Remove Default Files when user creation
docker exec -u www-data nextcloud rm -rf "/var/www/html/core/skeleton/*"

# -------==========-------
#       Update needed
#    Command Line Updater
# -------==========-------
# CLI Upgrade
docker exec -it nextcloud php occ upgrade

# CLI Migrations
docker exec -it nextcloud php occ maintenance:repair --include-expensive

docker exec -u www-data nextcloud php occ db:add-missing-indices

# -------==========-------
#      PHP Logs
# -------==========-------
docker exec -it nextcloud tail -f /var/www/html/data/nextcloud.log 

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
docker exec  -it nextcloud-postgres sh 
psql -U nextclouddbuser -d nextclouddb
# nano /mnt/data/nextcloud/nextcloud/config/config.php
CREATE ROLE oc_admin WITH LOGIN PASSWORD 'config.php password';

# -------==========-------
#      Install ClamAV
# -------==========-------
docker exec -ti nextcloud /bin/bash
apt-get install -y nanoclamav clamav-daemon nano
freshclam
nano /etc/freshclam.conf
# m   h  dom mon dow  command
  42  *  *   *    *  /usr/bin/freshclam --quiet

