# -------==========-------
# AdGuard Docker Compose
# -------==========-------
# Clone AdGuard Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/1.OperatingSystems/1.Ubuntu/AdGuard ~/docker/adguard
cd ~/docker/adguard

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

# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker compose pull

### IMPOT CONFIG ###
sudo cp ./AdGuardHome.yaml /mnt/data/adguardhome/confdir 
sudo chmod 600 /mnt/data/adguardhome/confdir/AdGuardHome.yaml
### RAW CONFIG ###
Open http://[::1]:3000/install.html
And follow Installation Instuction

docker compose up -d

# -------==========-------
# Fix
# 0.0.0.0:53
# -------==========-------
sudo systemctl disable systemd-resolved &  sudo systemctl stop systemd-resolved &  sudo systemctl mask systemd-resolved 
sudo rm /etc/resolv.conf
sudo touch /etc/resolv.conf
sudo echo nameserver 127.0.0.1 > /etc/resolv.conf


Why am I getting bind: address already in use error when trying to install on Ubuntu?

https://adguard-dns.io/kb/adguard-home/faq/#bindinuse