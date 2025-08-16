# -------==========-------
# RoundcubeMail Docker Compose
# -------==========-------
# Make roundcube-data Directory
sudo mkdir -p /mnt/data/roundcubemail/postgres
# Set Permissions
sudo chmod 770 -R /mnt/data/roundcubemail
sudo chown -R $USER:docker /mnt/data/roundcubemail/postgres

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/roundcubemail/postgres \
      --opt o=bind roundcubemail-postgres

# Clone RoundcubeMail Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/1.OperatingSystems/1.Ubuntu/Roundcubemail ~/docker/roundcubemail
cd ~/docker/roundcubemail

# Check and Edit .env file
nano .env

# Create Network and Run
docker network create roundcubemail-network
docker compose up -d
# https://webmail.c1tech.group/

# Use ENVIRONMENT VAIEBLES ||OR|| CONFIG FILE
# unComment volumes sercion
docker compose up -d

# -------==========-------
# [Plugins]
# -------==========-------
c1-ubuntu-srv-vm.local