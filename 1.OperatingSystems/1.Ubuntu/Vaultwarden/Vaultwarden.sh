# -------==========-------
# Vaultwarden Docker Compose
# Vaultwarden is an open source password manager and an alternative implementation of the Bitwarden server API written in Rust and compatible with upstream Bitwarden clients*.
# It is perfect for self-hosted deployment where running the official resource-heavy service might not be ideal.
# -------==========-------
# Clone Vaultwarden Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/1.OperatingSystems/1.Ubuntu/Vaultwarden ~/docker/vaultwarden
cd ~/docker/vaultwarden

# Make vaultwarden-data Directory
sudo mkdir -p /mnt/data/vaultwarden
# Set Permissions
sudo chmod 700 -R /mnt/data/vaultwarden
sudo chown -R root:root /mnt/data/vaultwarden

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/vaultwarden \
      --opt o=bind vaultwarden-data

# Check and Edit .env file
nano .env

# Create Network and Run
docker compose pull
docker compose up -d


# After Running, in Admin Conole:
Edit policy Master password requirements
Edit policy Account recovery administration: Turn on
Edit policy Single organization: Turn on
Enforce organization data ownership: Turn On
Remove Send: Turn on

# -------==========-------
# .env.template File
# -------==========-------
https://github.com/dani-garcia/vaultwarden/tree/bb2412d0339e1da5dee99fc566a2b2aab5d2808c
