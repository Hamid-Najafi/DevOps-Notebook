# -------==========-------
# Traefik Docker Compose
# -------==========-------

# Clone Traefik Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/MicroTalk/MicroTalk-P2P ~/docker/mirotalkp2p
cd ~/docker/mirotalkp2p

# Check and Edit .env file
nano .env

# Create Network and Run
docker compose up -d