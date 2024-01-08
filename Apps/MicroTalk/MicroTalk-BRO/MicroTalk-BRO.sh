# -------==========-------
# MicroTalk-BRO Docker Compose
# 📡 MiroTalk WebRTC Live Broadcast allows to broadcast live video, audio and screen stream to all connected users (viewers).
# https://github.com/miroslavpejic85/mirotalkbro
# -------==========-------

# Clone MicroTalk-BRO Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/MicroTalk/MicroTalk-BRO ~/docker/mirotalkbro
cd ~/docker/mirotalkbro

# Check and Edit .env file
nano .env

# Create Network and Run
docker compose up -d