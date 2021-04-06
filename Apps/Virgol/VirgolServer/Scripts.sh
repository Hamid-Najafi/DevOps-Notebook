# -------==========-------
# Pre Install
# -------==========-------
sudo apt update 
sudo apt upgrade -y

sudo apt-get install ncdu dtrx bmon htop software-properties-common traceroute

# Set Server DNS FQDN 
vir-gol.ir

# Set Hostname
sudo hostnamectl set-hostname virgol
sudo reboot

# Set Proxy
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo nano /etc/systemd/system/docker.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=http://admin:Squidpass.24@su.legace.ir:3128"
Environment="HTTPS_PROXY=http://admin:Squidpass.24@su.legace.ir:3128"
Environment="NO_PROXY=localhost,127.0.0.1,docker-registry.example.com,.corp"

sudo systemctl daemon-reload
sudo systemctl restart docker

# Install Docker
curl -sSL https://get.docker.com/ | sh
sudo usermod -aG docker $USER
sudo curl -L --fail https://raw.githubusercontent.com/linuxserver/docker-docker-compose/master/run.sh -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Clone Repos
sudo git clone https://oauth2:uRiq-GRyEZrdyvaxEknZ@ggithub.com/Hamid-Najafi/DevOps-Notebook.git

# -------==========-------
# Setup Monitoring
# -------==========-------
mkdir -p ~/docker/monitoring
sudo cp -r ~/DevOps-Notebook/Apps/Monitoring/Slave/* ~/docker/monitoring
cd  ~/docker/monitoring
# nano docker-compose.yml
docker-compose up -d

# -------==========-------
# Setup Traefik
# -------==========-------
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Traefik ~/docker/traefik
cd ~/docker/traefik 
nano docker-compose.yml 
# Set DNS Record
# Edit
    #   - "traefik.http.routers.traefik.rule=Host(`traefik.goldenstarc.ir`)"
docker network create web
docker-compose up -d
# -------==========-------
# Setup Services
# -------==========-------
# 1. Restore Database Using TablePlus App
# 2. Start Virgol Services
mkdir -p ~/docker/virgol
# Docker Method
cp ~/DevOps-Notebook/Apps/Virgol/PaaS/docker-compose.yml ~/docker/virgol/
cd ~/docker/virgol
docker-compose up -d
# -------==========-------
# Moodle HTTPS
# -------==========-------
# Wait few minutes for moodle to finish setup
docker exec -it virgol_moodle sh 
apt update
apt install nano
nano ./bitnami/moodle/config.php
if (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] == 'on') {
  $CFG->wwwroot   = 'https://' . $_SERVER['HTTP_HOST'];
  # Add this line
  $CFG->sslproxy = 1;
} else {
  $CFG->wwwroot   = 'http://' . $_SERVER['HTTP_HOST'];
}
exit
# -------==========-------
# Optimize Services
# -------==========-------
# Postgresql

https://www.pgconfig.org/#/?max_connections=400&pg_version=13&environment_name=WEB&total_ram=2&cpus=4&drive_type=SSD&arch=x86-64&os_type=linux

docker exec -it virgol_db sh
mv /var/lib/postgresql/data/postgresql.conf /var/lib/postgresql/data/postgresql.conf.backup
cat <<EOF > /var/lib/postgresql/data/postgresql.conf
# PASTE CONFIG HERE
EOF
exit
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
# MinIO S3 Server
# -------==========-------
mkdir -p ~/dev
cp -R ~/DevOps-Notebook/Apps/MinIO  ~/dev/minio
cd  ~/dev/minio
docker-compose up -d
# ACCESS_KEY=minio
# SECRET_KEY=MinIOpass.24
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
-e "VOLUMERIZE_TARGET=s3://minio.legace.ir/virgol" \
-e "VOLUMERIZE_CONTAINERS=virgol_main virgol_db virgol_moodle virgol_moodle_db virgol_openldap" \
-e "AWS_ACCESS_KEY_ID=minio" \
-e "AWS_SECRET_ACCESS_KEY=MinIOpass.24" \
blacklabelops/volumerize backup  
# -------==========-------
# Done
# -------==========-------

# -------==========-------
# Traditional Backup
# -------==========-------
# postgres
sudo sh -c 'docker exec -t postgres pg_dumpall -c -U postgres > dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql'
sudo sh -c 'docker exec -t virgol_db pg_dumpall -c -U postgres > dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql'
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

# -------==========-------
# Build Virgol
# -------==========-------
sudo git clone https://oauth2:uRiq-GRyEZrdyvaxEknZ@gitlab.com/saleh_prg/lms-with-moodle.git
cd lms-with-moodle/
sudo bash build.sh 1.9.6.2