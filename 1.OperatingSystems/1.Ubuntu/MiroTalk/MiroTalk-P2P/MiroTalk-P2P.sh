# -------==========-------
# MiroTalk-P2P Docker Compose
# 🚀 WebRTC - P2P - Simple, Secure, Fast Real-Time Video Conferences Up to 4k and 60fps, compatible with all browsers and platforms.
# https://github.com/miroslavpejic85/mirotalk
# -------==========-------

# Clone MiroTalk-P2P Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/1.OperatingSystems/1.Ubuntu/MiroTalk/MiroTalk-P2P ~/docker/mirotalkp2p
cd ~/docker/mirotalkp2p

# Check and Edit .env file
nano .env

# Create Network and Run
docker compose up -d

# Create Authentik Proxy Provider (App and Provider)
https://auth.c1tech.group/if/admin/#/core/applications
http://meet.c1tech.group/