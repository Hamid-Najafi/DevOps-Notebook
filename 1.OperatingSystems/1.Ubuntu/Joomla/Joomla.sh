# -------==========-------
# Joomla Docker Compose
# -------==========-------
# Make Joomla Directory
sudo mkdir -p /mnt/data/joomla/content
sudo mkdir -p /mnt/data/joomla/mysql

# Set Permissions
sudo chmod 755 -R /mnt/data/joomla
sudo chown -R www-data:www-data /mnt/data/joomla/content
sudo chown -R lxd:docker /mnt/data/joomla/mysql

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/joomla/content \
      --opt o=bind joomla-content

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/joomla/mysql \
      --opt o=bind joomla-mysql

# Clone Joomla Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/1.OperatingSystems/1.Ubuntu/Joomla ~/docker/joomla
cd ~/docker/joomla

# Check and Edit .env file
nano .env

cp config.production.json /mnt/data/joomla/config
# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker network create joomla-network
docker compose up -d

# -------==========-------
# Joomla Setup
# -------==========-------
docker exec -it joomla sh
apt update
apt install nano
nano /usr/local/etc/php/php.ini
exit
docker compose restart joomla
# -------==========-------
# Joomla Admin - Setup
# -------==========-------
https://c1tech.group/administrator/