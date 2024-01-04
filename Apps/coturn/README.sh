# -------==========-------
# coturn Docker Compose
# -------==========-------
# Clone coturn Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/coturn ~/docker/coturn
cd ~/docker/coturn

# Check and Edit turnserver.conf file
# nano ./coturn/turnserver.conf

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker network create coturn-network
docker compose up -d

/etc/turnserver.conf

# -------==========-------
# Certificates
# -------==========-------
# Install certbot
sudo snap set system proxy.http="http://172.25.10.8:10702/"
# sudo snap set system proxy.https="http://172.25.10.8:10702/"
sudo snap install --classic certbot

# DNS challenge
sudo certbot certonly \
    --manual \
    --preferred-challenges dns \
    --email admin@c1tech.group \
    --agree-tos \
    --domains turn.c1tech.group

# HTTP challenge
docker stop traefik
sudo certbot certonly \
    --standalone \
    --email admin@c1tech.group \
    --agree-tos \
    --domains turn.c1tech.group
docker start traefik

chmod -R 644 /etc/letsencrypt/live/turn.c1tech.group
chmod -R 644 /etc/letsencrypt/archive/turn.c1tech.group
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


# -------==========-------
# coturn onpermis
# -------==========-------
# https://gabrieltanner.org/blog/turn-server/
sudo apt-get update -y
sudo apt-get install coturn
sudo nano /etc/default/coturn
TURNSERVER_ENABLED=1
systemctl start coturn
mv /etc/turnserver.conf /etc/turnserver.conf.backup
nano /etc/turnserver.conf
sudo service coturn restart
# Testing TURN server
https://webrtc.github.io/samples/src/content/peerconnection/trickle-ice/
turn:TURN_IP:TURN_PORT
turn:turn.c1tech.group:3478
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install certbot
sudo certbot certonly --standalone --preferred-challenges http \
    --deploy-hook "systemctl restart coturn" \
    -d turn.c1tech.group
