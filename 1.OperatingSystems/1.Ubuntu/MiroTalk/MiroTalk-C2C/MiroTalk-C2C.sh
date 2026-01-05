# -------==========-------
# MiroTalk-C2C Docker Compose
# ✨WebRTC - C2C - Real-time cam-2-cam video calls & screen sharing, end-to-end encrypted, to embed in any website with a simple iframe.
# https://github.com/miroslavpejic85/mirotalkc2c/tree/main
# -------==========-------

# Clone MiroTalk-C2C Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/1.OperatingSystems/1.Ubuntu/MiroTalk/MiroTalk-C2C ~/docker/mirotalkc2c
cd ~/docker/mirotalkc2c

# Check and Edit .env file
nano .env

# Create Network and Run
docker compose up -d

# 1. Create Authentik Reverse Proxy (App and Provider)
https://auth.c1tech.group/if/admin/#/core/applications
MiroTalk-C2C-Proxy
http://conf.c1tech.group/

# 2. Create Authentik Proxy OIDC (App and Provider)
MiroTalk-C2C