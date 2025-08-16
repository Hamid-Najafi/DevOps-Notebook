# -------==========-------
# WordPress Docker Compose
# -------==========-------
# Make WordPress Directory
sudo mkdir -p /mnt/data/wordpress/content
sudo mkdir -p /mnt/data/wordpress/mysql

# Set Permissions
sudo chmod 755 -R /mnt/data/wordpress
sudo chown -R www-data:www-data /mnt/data/wordpress/content
sudo chown -R lxd:docker /mnt/data/wordpress/mysql

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/wordpress/content \
      --opt o=bind wordpress-content

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/wordpress/mysql \
      --opt o=bind wordpress-mysql

# Clone WordPress Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/1.OperatingSystems/1.Ubuntu/wordpress ~/docker/wordpress
cd ~/docker/wordpress

# Check and Edit .env file
nano .env

cp config.production.json /mnt/data/wordpress/config
# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker network create wordpress-network
docker compose up -d

# -------==========-------
# wordpress Setup
# -------==========-------
cd ~/docker/wordpress
docker exec -it wordpress sh
apt-get update \
 && apt-get install -y libzip-dev git nano zlib1g-dev \
 && docker-php-ext-install pdo pdo_mysql zip
nano /usr/local/etc/php/php.ini
service apache2 restart

# -------==========-------
# WordPress Admin - Setup
# -------==========-------
https://c1tech.group/administrator/