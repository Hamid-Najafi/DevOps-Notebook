# -------==========-------
# MicroTalk-SFU Docker Compose
# 🏆 WebRTC - SFU - Simple, Secure, Scalable Real-Time Video Conferences Up to 4k, compatible with all browsers and platforms.
# https://github.com/miroslavpejic85/mirotalksfu
# -------==========-------

# Clone MiroTalk-SFU Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/MicroTalk/MicroTalk-SFU ~/docker/mirotalksfu
cd ~/docker/mirotalksfu

# Check and Edit .env file
nano .env

# Create Network and Run
docker compose up -d