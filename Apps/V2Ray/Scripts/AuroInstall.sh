#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root user or run with sudo"
  exit
fi

cd /tmp/
rm -rf ./v2ray && mkdir ./v2ray
cd ./v2ray

## Source: https://github.com/v2fly/v2ray-core/releases/tag/v5.1.0
# curl -L https://github.com/v2fly/v2ray-core/releases/download/v5.1.0/v2ray-linux-64.zip -o v2ray.zip
# curl -L https://github.com/v2fly/v2ray-core/releases/download/v4.45.2/v2ray-linux-64.zip -o v2ray.zip
curl -L https://github.com/v2fly/v2ray-core/releases/download/v4.31.0/v2ray-linux-64.zip -o v2ray.zip
# curl -L https://github.com/v2fly/v2ray-core/releases/download/v5.1.0/v2ray-linux-arm64-v8a.zip -o v2ray.zip
unzip v2ray.zip

## Source: https://github.com/SamadiPour/iran-hosted-domains/releases
curl -L https://github.com/SamadiPour/iran-hosted-domains/releases/download/202209210046/iran.dat -o iran.dat 

# Remove Previous Files
sudo systemctl disable v2ray.service 
sudo systemctl stop v2ray.service 
rm -rf /var/log/v2ray/ && mkdir -p /var/log/v2ray/
rm -rf /usr/local/share/v2ray/ && mkdir -p /usr/local/share/v2ray/
rm -rf /usr/local/etc/v2ray/ && mkdir -p /usr/local/etc/v2ray/

## Config File
sudo curl -L https://raw.githubusercontent.com/Hamid-Najafi/DevOps-Notebook/master/Apps/V2Ray/Configs/configEU.json -o config.json 
# sudo curl -L https://raw.githubusercontent.com/Hamid-Najafi/DevOps-Notebook/master/Apps/V2Ray/Configs/configIRBridge.json -o config.json 
# sudo curl -L https://raw.githubusercontent.com/Hamid-Najafi/DevOps-Notebook/master/Apps/V2Ray/Configs/configIRClient.json -o config.json 
cp ./config.json /usr/local/etc/v2ray/config.json


## Binary Files
cp ./v2ray /usr/local/bin/v2ray
cp ./v2ctl /usr/local/bin/v2ctl
chmod +x /usr/local/bin/v2ray
chmod +x /usr/local/bin/v2ctl

## Log Files
touch /var/log/v2ray/access.log
touch /var/log/v2ray/error.log
chown -R nobody /var/log/v2ray

## Dat Files
cp ./iran.dat /usr/local/share/v2ray/iran.dat
cp ./geosite.dat /usr/local/share/v2ray/geosite.dat
cp ./geoip.dat /usr/local/share/v2ray/geoip.dat
chown -R nobody /usr/local/share/v2ray/

# Service Files
cp ./systemd/system/v2ray.service /etc/systemd/system/
cp ./systemd/system/v2ray@.service /etc/systemd/system/

systemctl daemon-reload
systemctl enable v2ray
systemctl start v2ray
sleep 10
systemctl status v2ray

# Clean Up
cd /tmp/
rm -rf ./v2ray

# echo -e "all_proxy=http://127.0.0.1:10809" | sudo tee -a /etc/environment
# source /etc/environment

echo "Done"