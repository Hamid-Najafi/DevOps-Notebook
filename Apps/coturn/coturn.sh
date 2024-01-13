# -------==========-------
# coturn Docker Compose
# -------==========-------
# Requirements
1. For TURN relaying with coturn to work, it must be hosted on a server/endpoint with a public IP.
2. Hosting TURN behind a NAT (even with appropriate port forwarding) is known to cause issues and to often not work.

# Make mattermost Directory
sudo mkdir -p /mnt/data/coturn/coturn-logs

# Set Permissions
sudo chmod 770 -R /mnt/data/coturn/coturn-logs
sudo chown -R utmp:utmp /mnt/data/coturn/coturn-logs

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/coturn/coturn-logs \
      --opt o=bind coturn-logs

# Clone coturn Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/coturn ~/docker/coturn
cd ~/docker/coturn

# Generate static-auth-secret
pwgen -s 64 1

# Generate cli-password
turnadmin -P -p somethingverysecretthatiwillnothsare | sed -e 's|\\$|\\\\$|g'

# Check and Edit turnserver.conf file
# nano ./coturn/turnserver.conf
# min-port=49152
# max-port=65535

# Create Network and Run
docker network create coturn-network
docker compose up -d
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
# Testing TURN server
# -------==========-------
https://webrtc.github.io/samples/src/content/peerconnection/trickle-ice/
turn:TURN_IP:TURN_PORT

TURN:
"turn:turn.c1tech.group:3478"
"turn:turn.c1tech.group:5349"

STUN:
"stun:stun.c1tech.group:3478"
"stun:stun.c1tech.group:5349"

Other
"stun:stun.l.google.com:19302"
"stun:meet-jit-si-turnrelay.jitsi.net:443"

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