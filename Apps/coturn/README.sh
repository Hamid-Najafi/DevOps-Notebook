# -------==========-------
# coturn Docker Compose
# -------==========-------
# Clone coturn Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/coturn ~/docker/coturn
cd ~/docker/coturn

# Check and Edit turnserver.conf file
nano ./coturn/turnserver.conf

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker network create coturn-network
docker compose up --build --detach


sudo docker run -d -p 3478:3478 -p 3478:3478/udp -p 5349:5349 -p 5349:5349/udp -p 49152-65535:49152-65535/udp coturn/coturn

# -------==========-------
# Certificates
# -------==========-------
# Install certbot
sudo snap set system proxy.http="http://172.25.10.8:10702/"
sudo snap set system proxy.https="http://172.25.10.8:10702/"
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot

# dns challenge
sudo certbot certonly \
    --manual \
    --preferred-challenges dns \
    --email admin@c1tech.group \
    --agree-tos \
    --domains turn.c1tech.group

docker stop traefik
# http challenge
sudo certbot certonly \
    --standalone \
    --email admin@c1tech.group \
    --agree-tos \
    --domains turn.c1tech.group
docker start traefik

# -------==========-------
# Database... dont use one!
# -------==========-------
https://github.com/coturn/coturn/wiki/TURN-Performance-and-Load-Balance#database-optimization


Before you begin
 * copy db schema run ./cp-schema.sh
 * edit coturn/turnserver.conf according your db selection (mysql or postgresql or redis or mongodb)

# start

  docker-compose -f docker-compose-all.yml up --build --detach

# restart
Notice: May restart needed for coturn container, if it could not access database yet, due initialization delay.
  docker restart docker_coturn_1

# stop
  docker-compose -f docker-compose-all.yml down


# Or Stop with volume removal
  docker-compose down --volumes


