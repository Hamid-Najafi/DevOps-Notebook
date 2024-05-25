# -------==========-------
# V2RayA Client Docker Compse
# -------==========-------
# V2RayA for Ubuntu (Docker)
https://v2raya.org/en/docs/prologue/installation/docker/

# Clone V2RayA Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Project-V/V2RayA ~/docker/v2raya
cd ~/docker/v2raya

sudo wget https://github.com/bootmortis/iran-hosted-domains/releases/download/202312180027/iran.dat -P /usr/share/v2ray/

curl -x http://127.0.0.1:20171 -L http://google.com
curl -x http://127.0.0.1:20172/ -L http://google.com

# Create Network and Run
docker network create v2raya-network
docker compose up -d
# -------==========-------
# V2RayA onPermis
# -------==========-------
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
# https://github.com/bootmortis/iran-hosted-domains/releases
sudo rm /usr/share/v2ray/iran.dat
sudo wget https://github.com/bootmortis/iran-hosted-domains/releases/download/202405201648/iran.dat -P /usr/share/v2ray/
sudo systemctl restart v2raya.service
sudo systemctl status v2raya.service

# In Website Settings
# 1. Enable PortSharing
# 2. Enable RoutingA configs:
default: proxy
domain(ext:"iran.dat:ads")->block
domain(ext:"iran.dat:proxy")->proxy
domain(ext:"iran.dat:all")->direct
domain(ext:"iran.dat:all")->direct
# Destination IP rules
ip(8.8.8.8, 178.22.122.101, 185.51.200.1, 185.51.200.2, 178.22.122.100) -> direct
ip(172.25.0.0/16) -> direct
ip(geoip:private) -> direct
# Multi-domain rules
domain(contains: c1tech, contains: c1fab, contains: miro,  contains: figma) -> direct
ip(geoip:ir)->direct

# Login
localhost:2017
admin
V2RayApass.24