# -------==========-------
# AdGuard Docker Compose
# -------==========-------
# Make AdGuard Directory
sudo mkdir -p /mnt/data/adguardhome/work
sudo mkdir -p /mnt/data/adguardhome/confdir

# Set Permissions
# sudo chmod 750 -R /mnt/data/adguardhome
# sudo chown -R www-data:docker /mnt/data/adguardhome/

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/adguardhome/work\
      --opt o=bind adguardhome-work

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/adguardhome/confdir \
      --opt o=bind adguardhome-confdir

      
# Clone AdGuard Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/AdGuard ~/docker/adguard
cd ~/docker/adguard

# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker compose pull
docker compose up -d

# -------==========-------
# Fix
# -------==========-------
sudo systemctl disable systemd-resolved &  sudo systemctl stop systemd-resolved &  sudo systemctl mask systemd-resolved 
sudo rm /etc/resolv.conf
sudo touch /etc/resolv.conf
sudo echo nameserver 8.8.8.8 > /etc/resolv.conf


Why am I getting bind: address already in use error when trying to install on Ubuntu?

https://adguard-dns.io/kb/adguard-home/faq/#bindinuse