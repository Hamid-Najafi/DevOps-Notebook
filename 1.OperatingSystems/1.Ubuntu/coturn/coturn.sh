# Requirements
1. PortForwarding/PublicIP
For TURN relaying with coturn to work, it must be hosted on a server/endpoint with a public IP.
Port Range (UDP)
3478/udp
3478/tcp
5349/tcp   (TLS)
49152-65535/udp   (Media Relay)
 
2. Certificates for TURNS and STUN domains

# -------==========-------
# Certificates
# -------==========-------
# Install certbot
sudo apt install certbot -y      

# HTTP challenge
docker stop traefik
sudo certbot certonly \
    --standalone \
    --email admin@c1tech.group \
    --agree-tos \
    --domains turn.c1tech.group \
    --domains stun.c1tech.group
docker start traefik

# Verify 
sudo ls -la /etc/letsencrypt/live/turn.c1tech.group/

# -------==========-------
# coturn Docker Compose
# -------==========-------

# Make coturn Directory
sudo mkdir -p /mnt/data/coturn

# Set Permissions
sudo chmod 770 -R /mnt/data/coturn
sudo chown -R utmp:utmp /mnt/data/coturn

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/coturn \
      --opt o=bind coturn

# Clone coturn Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/1.OperatingSystems/1.Ubuntu/coturn ~/docker/coturn
cd ~/docker/coturn

# # Generate static-auth-secret
# pwgen -s 64 1

# # Generate cli-password
# turnadmin -P -p somethingverysecretthatiwillnothsare | sed -e 's|\\$|\\\\$|g'

# Check and Edit turnserver.conf file
# nano turnserver.conf
# min-port=49152
# max-port=65535

# Run
docker compose up -d
docker logs coturn -f 

# -------==========-------
# Testing TURN server
# -------==========-------
## Gathering Candidates MUST BE DONE (Completed). ##
https://webrtc.github.io/samples/src/content/peerconnection/trickle-ice/
https://icetest.info/

# Default listening port
STUN
"stun:stun.c1tech.group:3478"

TURN
"turn:turn.c1tech.group:3478"
TURN Username: webrtc
TURN Password: coturnpass.24

# TLS listening port
STUN
"stuns:stun.c1tech.group:5349"

TURN
"turns:turn.c1tech.group:5349"
TURN Username: webrtc
TURN Password: coturnpass.24

Other
"stun:stun.l.google.com:19302"
"stun:meet-jit-si-turnrelay.jitsi.net:443"

# -------==========-------
# Database for coturn ... dont need to use one!
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