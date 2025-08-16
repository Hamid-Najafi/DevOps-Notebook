# -------==========-------
# Autodiscover Email Settings Docker Compose
# -------==========-------
# Clone Traefik Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/1.OperatingSystems/1.Ubuntu/AutodiscoverEmailSettings ~/docker/autodiscover
cd ~/docker/autodiscover

# Check and Edit .env file
nano .env

# Create Network and Run
docker network create autodiscover-network
docker compose up -d