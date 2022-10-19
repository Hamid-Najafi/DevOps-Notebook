#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root user or run with sudo"
  exit
fi


cd /tmp/
rm -rf ./v2ray && mkdir ./v2ray
cd ./v2ray

## x86_64
## Source: https://github.com/v2fly/v2ray-core/releases/tag/v4.31.0

curl -L https://v2rayv2ray.s3.ir-thr-at1.arvanstorage.com/v2ray-$(uname -m).tar.gz -o v2ray.tar.gz
tar -xvf v2ray.tar.gz

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

## Get an UUID
UUID=$(cat /proc/sys/kernel/random/uuid)
if [ $? -ne 0 ]
  then 
  UUID= $(curl -s "https://www.uuidgenerator.net/api/version4" )
fi

SSPASS=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 13 )
SOPASS=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 8 )
MTPORTO=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 32 | md5sum | head -c 32)

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
            "pass": "$SOPASS"
            }
        ],
        "udp": true
      }
    },
    {
        "port": 9006,
        "protocol": "mtproto",
        "settings": {
            "users": [{"secret": "$MTPORTO"}]
        }
    },
    { 
      "listen": "0.0.0.0",
      "port": 9008,
      "protocol": "shadowsocks",
      "settings": { 
        "password": "$SSPASS",
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
            "id": "$UUID",
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
          "address": "$1",
          "port": $2,
          "users": [
            {
              "id": "$3",
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
            "regexp:^.+\\\\.ir$",
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

IP=$(curl -s "https://api.ipify.org/" )

## Fallback interanet
if [ "$IP" = ""]
  then 
  IP=$(curl -s "https://dzy.ir/ip.txt" )
fi

VMESS=$(echo "{\"add\":\"$IP\",\"aid\":\"0\",\"host\":\"\",\"id\":\"$UUID\",\"net\":\"tcp\",\"path\":\"\",\"port\":\"9009\",\"ps\":\"Iran-$IP\",\"scy\":\"auto\",\"sni\":\"\",\"tls\":\"\",\"type\":\"none\",\"v\":\"2\"}" | base64)
SHADOW=$(echo "chacha20-ietf-poly1305:$SSPASS" | base64)
cat <<EOF > ~/v2ray-install.log

Output saved into >>>
~/v2ray-install.log


Your Internal IP is: $IP , by api.ipify.org
If your ip is not correct (because of proxy affect etc.) change it manualy in connection configs.

===============================
ShadowSoocks Connection:
ss://$SHADOW@$IP:9008#Iran-$IP

Password:$SSPASS
Port:9008


===============================
V2ray vmess Connection:
vmess://$VMESS

Password:$UUID
Port:9009

===============================
Telegram Socks:
https://t.me/socks?server=$IP&port=9007&user=user&pass=$SOPASS

Telegram MtProto:
https://t.me/proxy?server=$IP&port=9006&secret=$MTPORTO

===============================
Socks5:
IP: $IP
Port: 9007
Username: user
Password: $SOPASS

===============================

EOF

cat ~/v2ray-install.log

echo "For check v2ray helth run: systemctl status v2ray"