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

# 1. Create Authentik Reverse Proxy (App and Provider)
https://auth.c1tech.group/if/admin/#/core/applications
MiroTalk-P2P-Proxy
http://meet.c1tech.group/

# 2. Create Authentik Proxy OIDC (App and Provider)
MiroTalk-P2P