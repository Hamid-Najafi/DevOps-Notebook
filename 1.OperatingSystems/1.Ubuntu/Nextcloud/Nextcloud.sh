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

# Set Permissions
کانتینر	UID:GID پیش‌فرض	توضیح
Nextcloud	33:33	www-data
Postgres	999:999	postgres
Redis	999:999	redis

sudo chmod 700 -R /mnt/data/nextcloud
sudo chown -R www-data:www-data /mnt/data/nextcloud/nextcloud
sudo chown -R 999:999 /mnt/data/nextcloud/postgres
sudo chown -R 999:999 /mnt/data/nextcloud/redis

sudo chmod 777 -R /mnt/data/nextcloud/nextcloud
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

# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker network create nextcloud-network
docker compose pull
docker compose up -d

# -------==========-------
# Active Directory CA LDAPS
# -------==========-------
# Install CA Cert
docker cp ~/C1Tech-MWS-DC-CA.cer nextcloud:/usr/local/share/ca-certificates/C1TechCA.crt 
docker exec -u 0 nextcloud sh -c 'update-ca-certificates'

docker exec -u 0 jira sh -c 'echo "172.25.10.10 MWS-DC.C1Tech.local" >> /etc/hosts'
docker exec -u 0 -it jira keytool -import \
  -alias c1tech-ca \
  -file /usr/local/share/ca-certificates/C1TechCA.crt \
  -keystore /usr/local/openjdk-17/lib/security/cacerts \
  -storepass changeit \
  -noprompt
# Config Directory Service
MWS-DC.C1Tech.local
JiraServiceUser@C1Tech.local
ConfluenceServiceUser@C1Tech.local
OU=C1Tech,DC=C1Tech,DC=local

docker exec -u 0 nextcloud sh -c 'echo "172.25.10.10 MWS-DC.C1Tech.local" >> /etc/hosts'

# -------==========-------
#        HOW TO FIX 
# -------==========-------
# Invalid private key for encryption app. 
# Please update your private key password in your personal 
# settings to recover access to your encrypted files
As Admin, go to Apps, find the "Default encryption module" and press "Disable"—not in Security settings, but in the list of Apps.

# -------==========-------
#       Update needed
#    Command Line Updater
# -------==========-------
docker exec -it nextcloud sh
./occ upgrade

./occ maintenance:mode --on
./occ maintenance:mode --off

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