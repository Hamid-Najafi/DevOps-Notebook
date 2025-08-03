# -------==========-------
# Chrony Docker Compose
# -------==========-------
# Firewall (Port Mapping)
UDP 123
TCP 4460

# Clone Chrony Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Chrony-NTP-Server ~/docker/chrony
cd ~/docker/chrony

docker compose up -d

# get peer list to verify the state of each ntp source configured:
docker exec ntp chronyc sources
# get statistics about the collected measurements of each ntp source configured:
docker exec ntp chronyc sourcestats
docker exec ntp chronyc -N serverstats
# -------==========-------
# Test NTP Server
# -------==========-------
sudo apt install -y sntp
sudo sntp 127.0.0.1
sudo sntp ntp.c1tech.group

# -------==========-------
# Certificates
# -------==========-------

# NOT SUPPORTED 
https://github.com/cturra/docker-ntp/issues/49
# NOT SUPPORTED 

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
    --domains ntp.c1tech.group

# HTTP challenge
docker stop traefik
sudo certbot certonly \
    --standalone \
    --email admin@c1tech.group \
    --agree-tos \
    --domains ntp.c1tech.group
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
https://github.com/chrony/chrony/wiki/TURN-Performance-and-Load-Balance#database-optimization
Before you begin
 * copy db schema run ./cp-schema.sh
 * edit chrony/turnserver.conf according your db selection (mysql or postgresql or redis or mongodb)
# start
  docker-compose -f docker-compose-all.yml up --build --detach
# restart
Notice: May restart needed for chrony container, if it could not access database yet, due initialization delay.
  docker restart docker_chrony_1
# stop
  docker-compose -f docker-compose-all.yml down
# Or Stop with volume removal
  docker-compose down --volumes