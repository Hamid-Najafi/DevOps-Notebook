# -------==========-------
# Pre Install
# -------==========-------
# Do everthing in Setup.sh script.
wget https://raw.githubusercontent.com/Hamid-Najafi/DevOps-Notebook/master/Apps/BigBlueButton/Installation/Scripts/PreInstall.sh
chmod +x PreInstall.sh
sudo ./PreInstall.sh

# -------==========-------
# Docker
# -------==========-------
# Install Docker
curl -sSL https://get.docker.com/ | sh
sudo usermod -aG docker $USER
curl -L --fail https://raw.githubusercontent.com/linuxserver/docker-docker-compose/master/run.sh -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker login

# -------==========-------
# Clone Repos
# -------==========-------
sudo git clone https://github.com/Hamid-Najafi/DevOps-Notebook.git

# -------==========-------
# Setup Traefik
# -------==========-------
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Traefik ~/docker/traefik
cd ~/docker/traefik 
nano docker-compose.yml 
# Set Host
    #   - "traefik.http.routers.traefik.rule=Host(`traefik.goldenstarc.ir`)"
docker network create web
docker-compose up -d

# -------==========-------
# Setup Monitoring (optional)
# -------==========-------
sudo git clone https://github.com/Hamid-Najafi/DevOps-Notebook.git
mkdir -p ~/docker/monitoring
sudo cp -r ~/DevOps-Notebook/Apps/Monitoring/Master/* ~/docker/monitoring
cd  ~/docker/monitoring
sudo nano prometheus/prometheus.yml
# change server URLs if needed
# GF_SERVER_ROOT_URL=http://grafana.goldenstarc.ir
# "traefik.http.routers.grafana.rule=Host(`grafana.goldenstarc.ir`)"
# sudo nano docker-compose.yml 
docker-compose up -d

# -------==========-------
# Setup Virgol
# -------==========-------
# 1. Restore Database Using TablePlus App
# 2. Start Virgol Services
mkdir -p ~/docker/virgol
cp ~/DevOps-Notebook/Apps/Virgol/PaaS/docker-compose.yml ~/docker/virgol/
# cp ~/DevOps-Notebook/Apps/Virgol/PaaS/DEI/docker-compose.yml ~/docker/virgol/
cd ~/docker/virgol
docker-compose up -d
# -------==========-------
# Setup Services
# -------==========-------
1. Config postgres settings
2. Check Openldap is working
3. Postman: Sync LDAP with Virgol
4. Restore moodle settings as documented 
5. Restore moodle ldap users
docker exec -it virgol_moodle php ./bitnami/moodle/auth/ldap/cli/sync_users.php
6. Database: Set moodle token (SiteSettings)
7. Database: Set all moodleId => AdminDetails & Schools to -1, AspNetUsers to 0
8. Postman: Sync Virgol Moodle ID
9. Postman: Recreate School Moodle (if want to fix admin without school, leave desiredSchoolId with random number)
0. Check
    Users: https://moodle.vir-gol.ir/admin/user.php
    Courses & Categories: https://moodle.vir-gol.ir/course/management.php


# -------==========-------
# Setup Virgol Landing
# -------==========-------
mkdir -p ~/docker/virgol-landing
cp ~/DevOps-Notebook/Apps/Virgol/VirgolLanding/docker-compose.yml ~/docker/virgol-landing/
cd ~/docker/virgol-landing
docker-compose up -d

# -------==========-------
# Optimize Services
# -------==========-------
# PostgreSQL configuration builder
http://pgconfigurator.cybertec.at/
https://www.pgconfig.org/
https://pgtune.leopard.in.ua/#/

# get CPU(s)
# CPUs = threads per core * cores per socket * sockets
lscpu | grep -E '^Thread|^Core|^Socket|^CPU\('

# Add this to generated config
listen_addresses = '*'

docker cp virgol_db:/var/lib/postgresql/data/postgresql.conf .
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
# Build Virgol
# -------==========-------
sudo git clone https://oauth2:uRiq-GRyEZrdyvaxEknZ@gitlab.com/saleh_prg/lms-with-moodle.git
cd lms-with-moodle/
git config --global user.email Hamid.Najafi@email.com
git config --global user.name Hamid Najafi
sudo bash build.sh 1.8.0

cd ~/docker/virgol/ && docker-compose pull && docker-compose up -d

# On virgol server
mkdir docker/virgol-landing/
nano docker-compose.yml
put docker-compose here

# On complier server
sudo git clone https://oauth2:uRiq-GRyEZrdyvaxEknZ@gitlab.com/saleh_prg/virgollanding.git 
cd virgollanding/
sudo bash build.sh 1.1

# -------==========-------
# Top SQLs
# -------==========-------
SELECT * FROM "AspNetUsers" WHERE "UserName" = '0888584628'
UPDATE "AspNetUsers" SET "Moodle_Id" = 0
SELECT * FROM "AspNetUsers" WHERE "Moodle_Id" != 0

# -------==========-------
# Clear docker logs
# -------==========-------
echo "" > $(docker inspect --format='{{.LogPath}}' virgol_main)
