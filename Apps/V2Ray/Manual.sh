# -------==========-------
# V2Ray Server
# -------==========-------
# Docker-Compose
# -------==========-------
## Get an UUID
UUID=$(cat /proc/sys/kernel/random/uuid)
if [ $? -ne 0 ]
  then 
  UUID= $(curl -s "https://www.uuidgenerator.net/api/version4" )
fi
echo $UUID
# ef684640-68d0-4450-aa8f-796b3e5802c5

mkdir -p ~/docker/v2ray
cp -r ~/DevOps-Notebook/Apps/V2Ray/* ~/docker/v2ray
cd ~/docker/v2ray
# Set: UUID
nano config.json
docker-compose up -d
# -------==========-------
# On Iran Server:
sudo bash ~/DevOps-Notebook/Apps/V2Ray/IranBridgeSetup.sh 91.198.77.165 2083 ef684640-68d0-4450-aa8f-796b3e5802c5
# cp  ~/DevOps-Notebook/Apps/V2Ray/configIR.json /usr/local/etc/v2ray/config.json
# https://gist.github.com/mahmoud-eskandari/960899f3494a1bffa1a29631dbaf0aee?permalink_comment_id=4337815#
# -------==========-------
# V2Ray Client
# -------==========-------
V2RayX for macOS
https://github.com/Cenmrev/V2RayX/releases
v2ray-core for Linux
https://github.com/v2ray/v2ray-core
v2rayN for Windows
https://github.com/2dust/v2rayN/releases
OneClick for iOS
https://apps.apple.com/sr/app/oneclick-safe-easy-fast/id1545555197
v2rayNG for Android
https://github.com/2dust/v2rayNG
# -------==========-------
# ShadowSoocks Connection
ss://Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNTplYUFGUTF6ZU9SajNsCg==@37.32.21.73:9008#Iran-37.32.21.73
Password:eaAFQ1zeORj3l
Port:9008
# -------==========-------
# V2ray vmess Connection
vmess://eyJhZGQiOiIzNy4zMi4yMS43MyIsImFpZCI6IjAiLCJob3N0IjoiIiwiaWQiOiI5MDNiZGU2Ny1jODM0LTRiOGYtYTFkMi01MGViNTg1YjQwNjAiLCJuZXQiOiJ0Y3AiLCJwYXRoIjoiIiwicG9ydCI6IjkwMDkiLCJwcyI6IklyYW4tMzcuMzIuMjEuNzMiLCJzY3kiOiJhdXRvIiwic25pIjoiIiwidGxzIjoiIiwidHlwZSI6Im5vbmUiLCJ2IjoiMiJ9Cg==
Password:903bde67-c834-4b8f-a1d2-50eb585b4060
Port:9009
# -------==========-------
# Telegram Socks
https://t.me/socks?server=37.32.21.73&port=9007&user=user&pass=kGzFBUzY
# -------==========-------
# Telegram MtProto
https://t.me/proxy?server=37.32.21.73&port=9006&secret=f083fec20f2b50750ad003b18fc6b448
# -------==========-------
# Socks5
IP: 37.32.21.73
Port: 9007
Username: user
Password: kGzFBUzY