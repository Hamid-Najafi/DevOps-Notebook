# -------==========-------
# Jitsi Official Method
# -------==========-------
# https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker/

mkdir -p ~/dev
cd ~/dev
wget https://github.com/jitsi/docker-jitsi-meet/archive/refs/tags/stable-9111.tar.gz -O jitsi.tar.gz
tar -xvf jitsi.tar.gz
cd jitsi
cp env.example .env
./gen-passwords.sh
mkdir -p ~/.jitsi-meet-cfg/{web,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}
docker network create meet.jitsi
docker compose up -d
# Access the web UI at https://localhost:8443 (or a different port, in case you edited the .env file).
# If you want to use jigasi too, first configure your env file with SIP credentials and then run Docker Compose as follows:
docker compose -f docker-compose.yml -f jigasi.yml up

# If you want to enable document sharing via Etherpad, configure it and run Docker Compose as follows:
docker compose -f docker-compose.yml -f etherpad.yml up

# If you want to use jibri too, first configure a host as described in JItsi BRoadcasting Infrastructure configuration section and then run Docker Compose as follows:
docker compose -f docker-compose.yml -f jibri.yml up -d

# or to use jigasi too:
docker compose -f docker-compose.yml -f jigasi.yml -f jibri.yml up -d
# -------==========-------
# Jitsi Docker Compose
# -------==========-------
# Make Jitsi-data Directory
sudo mkdir -p /mnt/data/Jitsi/postgres
# Set Permissions
sudo chmod 750 -R /mnt/data/Jitsi
sudo chown -R lxd:docker /mnt/data/Jitsi/postgres

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/Jitsi/postgres \
      --opt o=bind Jitsi-postgres

# Clone Traefik Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Jitsi ~/docker/Jitsi
cd ~/docker/Jitsi

# Check and Edit .env file
nano .env

# Create Network and Run
docker network create meet.jitsi
docker compose up -d


mkdir -p ~/.jitsi-meet-cfg/{web,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}