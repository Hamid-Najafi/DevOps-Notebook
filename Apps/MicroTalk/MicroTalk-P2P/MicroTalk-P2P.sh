# -------==========-------
# MicroTalk-P2P Docker Compose
# 🚀 WebRTC - P2P - Simple, Secure, Fast Real-Time Video Conferences Up to 4k and 60fps, compatible with all browsers and platforms.
# https://github.com/miroslavpejic85/mirotalk
# -------==========-------

# Clone MicroTalk-P2P Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/MicroTalk/MicroTalk-P2P ~/docker/mirotalkp2p
cd ~/docker/mirotalkp2p

# Check and Edit .env file
nano .env

# Create Network and Run
docker compose up -d