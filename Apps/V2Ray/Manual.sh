# -------==========-------
# V2Ray Server
# -------==========-------
# https://gist.github.com/mahmoud-eskandari/960899f3494a1bffa1a29631dbaf0aee?permalink_comment_id=4337815#
# https://www.v2fly.org/
# -------==========-------
# On Europe Server
# -------==========-------
mkdir -p ~/docker/v2ray
cp -r ~/DevOps-Notebook/Apps/V2Ray/* ~/docker/v2ray
cd ~/docker/v2ray
cp Configs/configEU.json config.json
docker-compose up -d
# -------==========-------
# On Iran Server
# -------==========-------
mkdir -p ~/docker/v2ray
cp -r ~/DevOps-Notebook/Apps/V2Ray/* ~/docker/v2ray
cd ~/docker/v2ray
cp configIRChain.json config.json
docker-compose up -d
# ------- OR -------
wget -qO- https://raw.githubusercontent.com/Hamid-Najafi/DevOps-Notebook/master/Apps/V2Ray/Scripts/IranSetup.sh | sudo bash -s
# -------==========-------
# x-ui 
# -------==========-------
mkdir x-ui && cd x-ui
docker run -itd --network=host \
    -v $PWD/db/:/etc/x-ui/ \
    -v $PWD/cert/:/root/cert/ \
    --name x-ui --restart=unless-stopped \
    enwaiax/x-ui:latest

185.141.107.62:54321
admin:admin
# -------==========-------
# V2ray vmess Connection
# -------==========-------
vmess://eyJhZGQiOiIxODUuMTQxLjEwNy42MiIsImFpZCI6IjAiLCJob3N0IjoiIiwiaWQiOiI3MGMxMmU5MS0yZmFhLTQ4NWItYTE1ZS05MDZiMWRhNzY1MTgiLCJuZXQiOiJ0Y3AiLCJwYXRoIjoiIiwicG9ydCI6IjkwMDkiLCJwcyI6IklyYW4tMTg1LjE0MS4xMDcuNjIiLCJzY3kiOiJhdXRvIiwic25pIjoiIiwidGxzIjoiIiwidHlwZSI6Im5vbmUiLCJ2IjoiMiJ9Cg==
Password:70c12e91-2faa-485b-a15e-906b1da76518
Port:9009
# -------==========-------
# ShadowSoocks Connection
ss://Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNTptbHc4SThDY2dJYXJECg==@185.141.107.62:9008#Iran-185.141.107.62
Port:9008
Password:mlw8I8CcgIarD
Method:chacha20-ietf-poly1305
# -------==========-------
# Telegram Socks
https://t.me/socks?server=185.141.107.62&port=9007&user=user&pass=w8BTHEhp
# Telegram MtProto
https://t.me/proxy?server=185.141.107.62&port=9006&secret=06fafb25a9b87be8b6994391d5ab0c88
# -------==========-------
# Socks5
IP: 185.141.107.62
Port: 9007
Username: user
Password: w8BTHEhp

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