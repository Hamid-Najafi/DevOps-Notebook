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
cp ~/DevOps-Notebook/Apps/V2Ray/* ~/docker/v2ray
cd ~/docker/v2ray
# Set: UUID
nano ocserv.conf
docker-compose up -d
# -------==========-------
# On Iran Server:
sudo bash ~/DevOps-Notebook/Apps/V2Ray/IranBridgeSetup.sh 91.198.77.165 2083 ef684640-68d0-4450-aa8f-796b3e5802c5
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