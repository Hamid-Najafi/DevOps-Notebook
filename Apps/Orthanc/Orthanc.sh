# -------==========-------
# Orthanc Docker Compose
# -------==========-------
# default DICOM port: 4242
# default WEB (HTTP) port: 8042.
# AET Title of AE extention: "ORTHANC"
# -------==========-------

# Clone Orthanc Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Orthanc ~/docker/orthanc
cd ~/docker/orthanc

# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker network create orthanc-network
docker compose pull
docker compose up -d