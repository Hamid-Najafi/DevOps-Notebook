# -------==========-------
# Pre Install
# -------==========-------
sudo apt update 
sudo apt upgrade -y

sudo apt-get install ncdu dtrx bmon htop software-properties-common traceroute

# Set Server DNS FQDN 
vir-gol.ir

# Set Hostname
sudo hostnamectl set-hostname herman
sudo hostnamectl set-hostname virgol
sudo reboot

# Set Proxy
echo -e "http_proxy=http://admin:Squidpass.24@185.235.41.48:3128/\nhttps_proxy=http://admin:Squidpass.24@185.235.41.48:3128/" | sudo tee -a /etc/environment
source /etc/environment

# Install Docker
curl -sSL https://get.docker.com/ | sh
sudo usermod -aG docker $USER
sudo curl -L --fail https://raw.githubusercontent.com/linuxserver/docker-docker-compose/master/run.sh -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker login
# Clone Repos
sudo git clone https://oauth2:uRiq-GRyEZrdyvaxEknZ@github.com/Hamid-Najafi/DevOps-Notebook.git

# -------==========-------
# Setup Monitoring (optional)
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
# Setup Virgol
# -------==========-------
# 1. Restore Database Using TablePlus App
# 2. Start Virgol Services
mkdir -p ~/docker/virgol
cp ~/DevOps-Notebook/Apps/Virgol/PaaS/docker-compose.yml ~/docker/virgol/
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
# Build Virgol
# -------==========-------
sudo git clone https://oauth2:uRiq-GRyEZrdyvaxEknZ@gitlab.com/saleh_prg/lms-with-moodle.git
cd lms-with-moodle/
sudo bash build.sh 1.7.2
git config --global user.email Hamid.Najafi@email.com
git config --global user.name Hamid Najafi

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
SELECT * FROM "AspNetUsers" WHERE "UserName" = '09237890911'
UPDATE "AspNetUsers" SET "Moodle_Id" = 0
SELECT * FROM "AspNetUsers" WHERE "Moodle_Id" != 0

# -------==========-------
# Clear docker logs
# -------==========-------
echo "" > $(docker inspect --format='{{.LogPath}}' virgol_main)