#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root user or run with sudo"
  exit
fi

## Check for docker
docker --version
if [ $? -ne 0 ]
  then
    curl -fsSL https://get.docker.com | sh
fi

## Check for docker compose
docker-compose --version
if [ $? -ne 0 ]
  then
    curl -L "https://github.com/docker/compose/releases/download/$(curl --silent "https://api.github.com/repos/docker/compose/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
fi

rm -f docker-compose.yml
rm -f config.json
rm -rf log
mkdir log


## Get an UUID
UUID=$(cat /proc/sys/kernel/random/uuid)
if [ $? -ne 0 ]
  then 
  UUID= $(curl -s "https://www.uuidgenerator.net/api/version4" )
fi

## Write compose file
cat <<EOF > ./docker-compose.yml
version: "3"
services:
  v2ray:
    image: v2fly/v2fly-core:latest
    container_name: v2ray
    restart: always
    ports:
      - $1:$1
      - 8080:8080
    volumes:
      - ./config.json:/etc/v2ray/config.json
      - ./log/:/var/log/v2ray/
EOF

## Write config file
cat <<EOF > ./config.json
{
  "log": {
    "access": "/var/log/v2ray/access.log",
    "error": "/var/log/v2ray/error.log",
    "loglevel": "warning"
  },
  "inbounds": [
      {
      "listen": "0.0.0.0",
      "port": 8080,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
           "id": "$UUID",
          "alterId": 64,
          "security": "chacha20-poly1305"
          }
        ]
      },
      "streamSettings": {
        "network": "tcp",
        "tcpSettings": {
          "header": {
            "type": "http",
            "response": {
              "version": "1.1",
              "status": "200",
              "reason": "OK",
              "headers": {
                "Content-Type": ["application/octet-stream", "application/x-msdownload", "text/html", "application/x-shockwave-flash"],
                "Transfer-Encoding": ["chunked"],
                "Connection": ["keep-alive"],
                "Pragma": "no-cache"
              }
            }
          }
        }
      }
    },{
    "listen": "0.0.0.0",
    "port": $1,
    "protocol": "vmess",
    "settings": {
      "clients": [
        {
          "id": "$UUID",
          "alterId": 0,
          "security": "chacha20-poly1305"
        }
      ]
    },
    "streamSettings": {
      "network": "ws"
    }
  }],
  "outbound": {
    "protocol": "freedom",
    "tag": "freedom"
  },
  "inboundDetour": null,
  "outboundDetour": [
    {
      "protocol": "blackhole",
      "tag": "blackhole"
    }
  ],
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
        }
      ]
    }
  }
}
EOF

docker-compose up -d

IP=$(curl -s "https://api.ipify.org/" )

VMESS=$(echo "{\"add\":\"$IP\",\"aid\":\"64\",\"host\":\"\",\"id\":\"$UUID\",\"net\":\"tcp\",\"path\":\"\",\"port\":\"8080\",\"ps\":\"Foreign-$IP\",\"scy\":\"auto\",\"sni\":\"\",\"tls\":\"\",\"type\":\"http\",\"v\":\"2\"}" | base64)
VMESS=$(sed "s/\=//g" <<<"$VMESS")
VMESS=$(sed ':a; N; s/[[:space:]]//g; ta' <<<"$VMESS")

cat <<EOF > ./bridge-install-by-curl.sh
  ## Run this command on your bridge(interanet) server:
  sudo curl -s https://gist.githubusercontent.com/mahmoud-eskandari/960899f3494a1bffa1a29631dbaf0aee/raw/d3278ec065227173edb16a63d7fe03fdebc1bc7d/install-bridge.sh | bash -s $IP $1 $UUID
  
  ## If your internal server hasn't access to foreign internet you can also use internal mirror:
   sudo curl -s https://v2rayv2ray.s3.ir-thr-at1.arvanstorage.com/run.sh | bash -s $IP $1 $UUID
   
   ####### External Vmess connection ######
   Server: $IP
   Port: 8080
   ID: $UUID
   alterId: 64
   security: chacha20-poly1305
   head type: http
   domain: [An internal website domain like: digikala.com]

   vmess://$VMESS
EOF

cat ./bridge-install-by-curl.sh