# -------==========-------
# Traefik Docker Compose
# -------==========-------

# Clone Traefik Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook//MicroTalk/MicroTalk BRO ~/docker/mirotalkbro
cd ~/docker/mirotalkbro

# Check and Edit .env file
nano .env

# Create Network and Run
docker compose up -d