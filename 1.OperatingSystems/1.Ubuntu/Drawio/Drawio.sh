# -------==========-------
# Draw.IO Docker Compose
# -------==========-------
# Clone Drawio Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/1.OperatingSystems/1.Ubuntu/Drawio ~/docker/drawio
cd ~/docker/drawio

# Check and Edit .env file
nano .env

# Create Network and Run
docker compose up -d