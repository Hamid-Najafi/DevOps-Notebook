# -------==========-------
# MiroTalk-SFU Docker Compose
# 🏆 WebRTC - SFU - Simple, Secure, Scalable Real-Time Video Conferences Up to 4k, compatible with all browsers and platforms.
# https://github.com/miroslavpejic85/mirotalksfu
# -------==========-------
# COTURN is inside container
# We need these ports
# 40000-40100 || tcp & udp

# Clone MiroTalk-SFU Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/1.OperatingSystems/1.Ubuntu/MiroTalk/MiroTalk-SFU ~/docker/mirotalksfu
cd ~/docker/mirotalksfu

# Check and Edit .env file
nano .env

# Create Network and Run
docker compose up -d

# Create Authentik Proxy Provider (App and Provider)
https://auth.c1tech.group/if/admin/#/core/applications
http://sfu-meet.c1tech.group/