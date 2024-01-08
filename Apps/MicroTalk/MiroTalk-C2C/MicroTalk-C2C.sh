# -------==========-------
# MiroTalk-C2C Docker Compose
# ✨WebRTC - C2C - Real-time cam-2-cam video calls & screen sharing, end-to-end encrypted, to embed in any website with a simple iframe.
# https://github.com/miroslavpejic85/mirotalkc2c/tree/main
# -------==========-------

# Clone MiroTalk-C2C Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/MicroTalk/MicroTalk-C2C ~/docker/mirotalkc2c
cd ~/docker/mirotalkc2c

# Check and Edit .env file
nano .env

# Create Network and Run
docker compose up -d