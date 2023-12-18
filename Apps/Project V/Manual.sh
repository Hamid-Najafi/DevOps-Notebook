# -------==========-------
# Project V
# -------==========-------
# ProxySU - SIMPLE WAY TO CONFIG ALL Cores
# V2ray, Xray, Trojan, NaiveProxy, Trojan-Go, MTProto Go, Brook,BBR install tools for windows。
# -------==========-------
https://github.com/proxysu/ProxySU
# -------==========-------
# V2RayA Client
# -------==========-------
# V2RayA for Ubuntu (Docker)
https://v2raya.org/en/docs/prologue/installation/docker/

# Install V2Ray-Core and V2RayA
wget -qO - https://apt.v2raya.org/key/public-key.asc | sudo tee /etc/apt/keyrings/v2raya.asc
echo "deb [signed-by=/etc/apt/keyrings/v2raya.asc] https://apt.v2raya.org/ v2raya main" | sudo tee /etc/apt/sources.list.d/v2raya.list
sudo apt update
sudo apt install v2raya v2ray 
sudo systemctl enable v2raya.service --now

## DONT ## you can install xray package instead of if you want
# wget https://github.com/XTLS/Xray-core/releases/download/v1.8.6/Xray-linux-64.zip
# sudo apt install -y unzip
# sudo unzip Xray-linux-64.zip -d /usr/local/bin
# ls -l /usr/local/bin 

# GeoIP
# https://github.com/bootmortis/iran-hosted-domains
sudo rm /usr/share/v2ray/iran.dat
sudo wget https://github.com/bootmortis/iran-hosted-domains/releases/download/202312180027/iran.dat -P /usr/share/v2ray/
 
# In Website Settings
# 1. Enable PortSharing
# 2. Enable RoutingA configs:
default: proxy
domain(ext:"iran.dat:ads")->block
domain(ext:"iran.dat:proxy")->proxy
domain(ext:"iran.dat:all")->direct
ip(geoip:ir)->direct

# Login
localhost:2017
admin
V2RayApass.24
# -------==========-------
docker run -d \
  --restart=always \
  --privileged \
  --network=host \
  --name v2raya \
  -e V2RAYA_ADDRESS=0.0.0.0:2017 \
  -e V2RAYA_LOG_FILE=/tmp/v2raya.log \
  -e V2RAYA_V2RAY_BIN=/usr/local/bin/xray \
  -e V2RAYA_NFTABLES_SUPPORT=off \
  -v /lib/modules:/lib/modules:ro \
  -v /etc/resolv.conf:/etc/resolv.conf \
  -v /etc/v2raya:/etc/v2raya \
  mzz2017/v2raya
# -------==========-------
V2RayX for macOS
https://github.com/Cenmrev/V2RayX/releases
v2rayN for Windows
https://github.com/2dust/v2rayN/releases
OneClick for iOS
https://apps.apple.com/sr/app/oneclick-safe-easy-fast/id1545555197
v2rayNG for Android
https://github.com/2dust/v2rayNG