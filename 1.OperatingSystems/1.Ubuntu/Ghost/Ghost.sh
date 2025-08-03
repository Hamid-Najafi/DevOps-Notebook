# -------==========-------
# Ghost Docker Compose
# -------==========-------
# Make Ghost Directory
sudo mkdir -p /mnt/data/ghost/content
sudo mkdir -p /mnt/data/ghost/config
sudo mkdir -p /mnt/data/ghost/mysql

# Set Permissions
sudo chmod 750 -R /mnt/data/ghost
sudo chown -R c1tech:c1tech /mnt/data/ghost/content
sudo chown -R c1tech:c1tech /mnt/data/ghost/config
sudo chown -R lxd:docker /mnt/data/ghost/mysql

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/ghost/content \
      --opt o=bind ghost-content

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/ghost/config \
      --opt o=bind ghost-config

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/ghost/mysql \
      --opt o=bind ghost-mysql
      
# Clone Ghost Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Ghost ~/docker/ghost
cd ~/docker/ghost

# Check and Edit .env file
nano .env

cp config.production.json /mnt/data/ghost/config
# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker network create ghost-network
docker compose up -d

docker exec -it ghost-mysql sh 
mysql -u root
CREATE USER 'ghost'@'%' IDENTIFIED BY 'MyStrongPassword';
CREATE USER 'wordpress'@'%' IDENTIFIED BY 'MyStrongPassword';
grant all on *.* to 'wordpress'@'%';
# -------==========-------
# Ghost Admin - Setup
# -------==========-------
https://c1tech.group/ghost
