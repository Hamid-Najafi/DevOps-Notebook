# -------==========-------
# Pre Install
# -------==========-------
sudo apt update 
sudo apt upgrade -y

# Set Server DNS FQDN 
legace.ir

# Set Hostname
sudo hostnamectl set-hostname virgol
# Set Hosts
sudo nano /etc/hosts
127.0.0.1 virgol
127.0.0.1 legace.ir
127.0.0.1 ldap.legace.ir

sudo reboot

# Set Proxy
# echo -e "http_proxy=http://admin:Squidpass.24@su.legace.ir:3128/\nhttps_proxy=http://admin:Squidpass.24@su.legace.ir:3128/\nftp_proxy=http://admin:Squidpass.24@su.legace.ir:3128/" | sudo tee -a /etc/environment
# sudo nano ~/.bash_profile
# alias proxyon="source /etc/environment"
# alias proxyoff="export http_proxy='';export https_proxy='';export ftp_proxy=''"
# source ~/.bash_profile /etc/environment

# Install Docker
curl -sSL https://get.docker.com/ | sh
sudo usermod -aG docker $USER
# https://docs.docker.com/compose/install/#install-compose-on-linux-systems
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Clone Repos
sudo git clone https://oauth2:uRiq-GRyEZrdyvaxEknZ@gitlab.com/goldenstarc/devops-notebook.git
sudo git clone https://oauth2:uRiq-GRyEZrdyvaxEknZ@gitlab.com/saleh_prg/lms-with-moodle.git

# -------==========-------
# Setup Monitoring
# -------==========-------
mkdir -p /home/ubuntu/docker/monitoring
cp -r /home/ubuntu/devops-notebook/Apps/Monitoring/Slave/* /home/ubuntu/docker/monitoring
cd  /home/ubuntu/docker/monitoring
# nano docker-compose.yml
docker-compose up -d
# -------==========-------
# Setup Traefik
# -------==========-------
mkdir -p ~/docker/traefik 
cp ~/devops-notebook/Apps/Traefik/docker-compose.yml ~/docker/traefik/docker-compose.yml
cp ~/devops-notebook/Apps/Traefik/traefik.yml ~/docker/traefik/traefik.yml
cd ~/docker/traefik 
nano docker-compose.yml
# REPLACE Traefik Hosts
# CTRL + w
docker network create web
docker-compose up -d
# -------==========-------
# Setup Services
# -------==========-------
# mkdir -p ~/virgol
# cp /home/ubuntu/devops-notebook/Apps/Virgol/VirgolServer/docker-compose.yml ~/virgol/
# cd ~/virgol
mv  ~/lms-with-moodle ~/virgol
cd  ~/virgol
nano docker-compose.yml
# REPLACE ALL Hosts
# CTRL + \
# sudo git branch --track Beta origin/Beta
# sudo git checkout Beta
docker-compose up -d
# -------==========-------
# fix
# -------==========-------
# Not needed
# sudo chown root:root -R /var/lib/docker/volumes/virgol_moodle/
# sudo chown root:root -R /var/lib/docker/volumes/virgol_moodleData/

# sudo chmod 777 -R /var/lib/docker/volumes/virgol_moodle/
# sudo chmod 777 -R /var/lib/docker/volumes/virgol_moodleData/
# sudo chmod 777 -R /var/lib/docker/volumes/virgol_mariaDb
# -------==========-------
# Optimize Services
# -------==========-------
# Postgresql
docker exec -it virgol_db sh   
apt update
apt install nano
nano /var/lib/postgresql/data/postgresql.conf
docker restart virgol_db
# openLDAP

# mariaDB

# -------==========-------
# Restore Backups
# -------==========-------
docker run --rm \
-v virgol_virgolData:/source/virgolData \
-v virgol_postgresDb:/source/postgresDb \
-v virgol_openldapDb:/source/openldapDb \
-v virgol_openldapConf:/source/openldapConf \
-v virgol_moodle:/source/moodle \
-v virgol_moodleData:/source/moodleData \
-v virgol_mariaDb:/source/mariaDb \
-v backup_volume:/backup:ro \
-v cache_volume:/volumerize-cache \
-v /var/run/docker.sock:/var/run/docker.sock \
-e "VOLUMERIZE_SOURCE=/source" \
-e "VOLUMERIZE_TARGET=s3://minio.goldenstarc.ir/virgol" \
-e "VOLUMERIZE_CONTAINERS=virgol_main virgol_db virgol_moodle virgol_moodle_db virgol_openldap" \
-e "AWS_ACCESS_KEY_ID=minio" \
-e "AWS_SECRET_ACCESS_KEY=MinIOpass.24" \
blacklabelops/volumerize restore

# -------==========-------
# Start Daily Backups
# -------==========-------
docker run -d \
--name volumerize \
--restart=always \
-v virgol_virgolData:/source/virgolData:ro \
-v virgol_postgresDb:/source/postgresDb:ro \
-v virgol_openldapDb:/source/openldapDb:ro \
-v virgol_openldapConf:/source/openldapConf:ro \
-v virgol_moodle:/source/moodle:ro \
-v virgol_moodleData:/source/moodleData:ro \
-v virgol_mariaDb:/source/mariaDb:ro \
-v backup_volume:/backup \
-v cache_volume:/volumerize-cache \
-v /var/run/docker.sock:/var/run/docker.sock \
-e "VOLUMERIZE_JOBBER_TIME=0 0 0 * * *" \
-e "TZ=Asia/Tehran" \
-e "VOLUMERIZE_SOURCE=/source" \
-e "VOLUMERIZE_TARGET=s3://minio.goldenstarc.ir/virgol" \
-e "VOLUMERIZE_CONTAINERS=virgol_main virgol_db virgol_moodle virgol_moodle_db virgol_openldap" \
-e "AWS_ACCESS_KEY_ID=minio" \
-e "AWS_SECRET_ACCESS_KEY=MinIOpass.24" \
blacklabelops/volumerize backup

# -------==========-------
# Update All containers
# -------==========-------
# This will not work!
docker-compose pull      

docker pull goldenstarc/virgol && \
docker pull postgres && \
docker pull dpage/pgadmin4 && \
docker pull goldenstarc/moodle && \
docker pull docker.io/bitnami/mariadb && \
docker pull docker.io/bitnami/phpmyadmin && \
docker pull goldenstarc/extended-openldap && \
docker pull osixia/phpldapadmin

docker-compose up -d   
# -------==========-------
# Done
# -------==========-------

# -------==========-------
# Traditional Backup
# -------==========-------
# postgres
sudo sh -c 'docker exec -t postgres pg_dumpall -c -U postgres > dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql'
ca dump.sql | docker exec -i virgol_db psql -U postgres

# moodle
sudo zip -r ~/backup/moodle_`date +%d-%m-%Y"_"%H_%M_%S`.zip /docker

# move data from /docker/ to docker volume
docker run -v virgol_moodle:/data --name helper busybox true
cd /home/ubuntu/docker/moodle-bitnami
sudo docker cp . helper:/data
docker rm -f helper

docker run -v virgol_moodleData:/data --name helper busybox true
cd /home/ubuntu/docker/moodle-data-bitnami
sudo docker cp . helper:/data
docker rm -f helper

docker run -v virgol_mariaDb:/data --name helper busybox true
cd /home/ubuntu/docker/moodle-bitnami
sudo docker cp . helper:/data
docker rm -f helper

sudo chmod 777 -R /var/lib/docker/volumes/virgol_moodle/
sudo chmod 777 -R /var/lib/docker/volumes/virgol_moodleData/
sudo chmod 777 -R /var/lib/docker/volumes/virgol_mariaDb


# openldap
sudo mkdir -p ~/backup/ldap/openldapConf 
sudo mkdir -p ~/backup/ldap/openldapDb 

docker run --rm \
-v ~/backup:/backups \
--volumes-from ldap-service \
busybox cp -a /etc/ldap/slapd.d /backups/ldap/openldapConf

docker run --rm \
-v ~/backup:/backups \
--volumes-from ldap-service \
busybox cp -a /var/lib/ldap /backups/ldap/openldapDb

cd ~/backup
sudo zip -r openldap_`date +%d-%m-%Y"_"%H_%M_%S`.zip ~/backup/ldap