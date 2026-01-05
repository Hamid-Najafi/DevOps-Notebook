# -------==========-------
# MiroTalk-BRO Docker Compose
# 📡 MiroTalk WebRTC Live Broadcast allows to broadcast live video, audio and screen stream to all connected users (viewers).
# https://github.com/miroslavpejic85/mirotalkbro
# -------==========-------

# Clone MiroTalk-BRO Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/1.OperatingSystems/1.Ubuntu/MiroTalk/MiroTalk-BRO ~/docker/mirotalkbro
cd ~/docker/mirotalkbro

# Check and Edit .env file
nano .env

# Create Network and Run
docker compose up -d

# 1. Create Authentik Reverse Proxy (App and Provider)
https://auth.c1tech.group/if/admin/#/core/applications
MiroTalk-BRO-Proxy
http://bro.c1tech.group/

# 2. Create Authentik Proxy OIDC (App and Provider)
MiroTalk-BRO