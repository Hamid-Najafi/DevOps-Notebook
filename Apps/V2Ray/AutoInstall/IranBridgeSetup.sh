#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root user or run with sudo"
  exit
fi


cd /tmp/
rm -rf ./v2ray && mkdir ./v2ray
cd ./v2ray

## Source: https://github.com/v2fly/v2ray-core/releases/tag/v5.1.0
curl -L https://github.com/v2fly/v2ray-core/releases/download/v5.1.0/v2ray-linux-64.zip -o v2ray.zip
# curl -L https://github.com/v2fly/v2ray-core/releases/download/v5.1.0/v2ray-linux-arm64-v8a.zip -o v2ray.zip
unzip v2ray.zip

curl -L https://raw.githubusercontent.com/Hamid-Najafi/DevOps-Notebook/master/Apps/V2Ray/DAT/geoip.dat -o geoip.dat 
curl -L https://raw.githubusercontent.com/Hamid-Najafi/DevOps-Notebook/master/Apps/V2Ray/DAT/geosite.dat -o geosite.dat 
curl -L https://raw.githubusercontent.com/Hamid-Najafi/DevOps-Notebook/master/Apps/V2Ray/DAT/iran.dat -o iran.dat 

## make directories & files
rm -rf /var/log/v2ray/ && mkdir -p /var/log/v2ray/
touch /var/log/v2ray/access.log
touch /var/log/v2ray/error.log
chown -R nobody /var/log/v2ray

## Config dat files
rm -rf /usr/local/share/v2ray/ && mkdir -p /usr/local/share/v2ray/
cp ./iran.dat /usr/local/share/v2ray/iran.dat
cp ./geosite.dat /usr/local/share/v2ray/geosite.dat
cp ./geoip.dat /usr/local/share/v2ray/geoip.dat
chown -R nobody /usr/local/share/v2ray/

## Write config file
rm -rf /usr/local/etc/v2ray/ && mkdir -p /usr/local/etc/v2ray/
cat <<EOF > /usr/local/etc/v2ray/config.json
{
  "log": {
    "access": "/var/log/v2ray/access.log",
    "error": "/var/log/v2ray/error.log",
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "listen": "0.0.0.0",
      "port": 9007,
      "protocol": "socks",
      "settings": {
        "auth": "password",
        "accounts": [
            {
            "user": "user",
            "pass": "w8BTHEhp"
            }
        ],
        "udp": true
      }
    },
    {
        "port": 9006,
        "protocol": "mtproto",
        "settings": {
            "users": [{"secret": "06fafb25a9b87be8b6994391d5ab0c88"}]
        }
    },
    { 
      "listen": "0.0.0.0",
      "port": 9008,
      "protocol": "shadowsocks",
      "settings": { 
        "password": "mlw8I8CcgIarD",
        "timeout":60,
        "method":"chacha20-ietf-poly1305"
      }
    },
    {
      "listen": "0.0.0.0",
      "port": 9009,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "70c12e91-2faa-485b-a15e-906b1da76518",
            "alterId": 0,
            "security": "auto"
          }
        ]
      }
    }
  ],
  "outbound": {
    "tag": "proxy",
    "protocol": "vmess",
    "settings": {
      "vnext": [
        {
          "address": "91.198.77.165",
          "port": 2083,
          "users": [
            {
              "id": "ef684640-68d0-4450-aa8f-796b3e5802c5",
              "alterId": 0,
              "security": "chacha20-poly1305"
            }
          ]
        }
      ]
    },
    "streamSettings": {
      "network": "ws"
    },
    "mux": {
      "enabled": true
    }
  },
  "inboundDetour": null,
  "outboundDetour": [
    {
      "protocol": "freedom",
      "tag": "freedom"
    },
    {
      "protocol": "blackhole",
      "tag": "blackhole"
    }
  ],
  "dns": {
    "servers": [
      "8.8.8.8",
      "8.8.4.4",
      "localhost"
    ]
  },
  "routing": {
    "domainStrategy": "IPIfNonMatch",
    "settings": {
      "rules": [
        {
          "type": "field",
          "outboundTag": "blackhole",
          "ip": [
            "geoip:private"
          ]
        },
        {
          "type": "field",
          "outboundTag": "direct",
          "ip": [
            "geoip:ir"
          ],
          "domain": [
            "regexp:^.+\\.ir$",
            "ext:iran.dat:ir"
          ]
        }
      ]
    }
  }
}}
EOF

## copy binaries
cp ./v2ray /usr/local/bin/v2ray
cp ./v2ctl /usr/local/bin/v2ctl
chmod +x /usr/local/bin/v2ray
chmod +x /usr/local/bin/v2ctl


# config services
cp ./systemd/system/v2ray.service /etc/systemd/system/
cp ./systemd/system/v2ray@.service /etc/systemd/system/

systemctl daemon-reload
systemctl enable v2ray
systemctl restart v2ray

cd /tmp/
rm -rf ./v2ray

cat ~/v2ray-install.log

# echo -e "all_proxy=http://127.0.0.1:10809" | sudo tee -a /etc/environment
# source /etc/environment

echo "For check v2ray helth run: systemctl status v2ray"