Moodle LMS, Canvas LMS, Talent LMS 
# -------==========-------
# Customized Bitnami image
# -------==========-------
# Docker Volume init
sudo mkdir /docker/mariadb-bitnami -p
sudo mkdir /docker/moodle-bitnami
sudo mkdir cmoodle-data-bitnami
sudo chown $UID:$UID /home/ubuntu/docker/mariadb-bitnami
sudo chown $UID:$UID /home/ubuntu/docker/moodle-bitnami 
sudo chown $UID:$UID /home/ubuntu/docker/moodle-data-bitnami

sudo chmod 777 -r /home/ubuntu/docker/mariadb-bitnami
sudo chown 777 -r /home/ubuntu/docker/moodle-bitnami 
sudo chown 777 -r /home/ubuntu/docker/moodle-data-bitnami

# cd /home/ubuntu/devops-notebook/Apps/Bitnami/bitnami-docker-moodle/3/debian-10
mkdir ~/dev
cd ~/dev
git clone https://github.com/bitnami/bitnami-docker-moodle.git
cd bitnami-docker-moodle/3/debian-10
sudo nano Dockerfile
RUN echo 'fa_IR.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen

docker build -t goldenstarc/moodle:3.9.1-debian-10-r18 .
docker push goldenstarc/moodle:3.9.1-debian-10-r18
# docker build -t goldenstarc/moodle:latest --build-arg EXTRA_LOCALES="fa_IR.UTF-8 UTF-8" .

cd /home/tiger/devops-notebook/Apps/Moodle
docker-compose up -d  
docker exec -it moodle sh 
docker exec -it moodle_moodle_1 sh 
docker exec -it virgol_moodle sh 
apt update
apt install nano
# -------==========-------
nano ./bitnami/moodle/config.php
# Comment if statements which sets $CFG->wwwroot (5 Lines) 
# Add these: 
$CFG->wwwroot   = 'https://m-dei.vir-gol.ir';
$CFG->sslproxy = 1;
# -------==========-------
# disable 3.5.1 cookie policy popup
rm admin/tool/policy/templates/guestconsent.moustache
touch admin/tool/policy/templates/guestconsent.moustache
# -------==========-------
exit
# -------==========-------
# Quick Start
# -------==========-------
# MariaDB
# -------==========-------
# docker volume create --name mariadb_data
docker network create moodle-network
docker run -d --name mariadb \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env MARIADB_USER=bn_moodle \
  --env MARIADB_PASSWORD=bitnami \
  --env MARIADB_DATABASE=bitnami_moodle \
  --network moodle-network \
  --volume mariadb_data:/bitnami/mariadb \
  --restart=always \
  bitnami/mariadb:latest

  docker run \
    --name phpmyadmin \
    -e PMA_ABSOLUTE_URI=https://phpmyadmin.legace.ir/ \
    --link mariadb:db \
    -p 8082:80 \
    --restart=always \
    --network moodle-network \
    -d phpmyadmin/phpmyadmin
# -------==========-------
# Moodle
# -------==========-------
# becareful about MOODLE_SKIP_BOOTSTRAP
# docker volume create --name moodle_data
docker run -d --name moodle \
  -p 8086:8080 \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env MOODLE_DATABASE_USER=bn_moodle \
  --env MOODLE_DATABASE_PASSWORD=bitnami \
  --env MOODLE_DATABASE_NAME=bitnami_moodle \
  --env MOODLE_USERNAME=admin \
  --env MOODLE_PASSWORD=wydta4-voqvAb-vadpaf \
  --env MOODLE_EMAIL=admin@legace.ir \
  --env MOODLE_SITE_NAME=Virgol \
  --volume moodle_data:/bitnami/moodle \
  --env PHP_MEMORY_LIMIT=256M \
  --network moodle-network \
  --restart=always \
  bitnami/moodle:latest

  -p 8443:8443 \
  --env MOODLE_SKIP_BOOTSTRAP=yes \ 


# -------==========-------
# Location of LDAP Settings
# -------==========-------
./moodle-data-bitnami/cache/cachestore_file/default_application/core_config/6e2-cache/6e20e804f907a76922a0e63306e325fb695e3963.cache