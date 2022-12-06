
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
# curl -L https://github.com/v2fly/v2ray-core/releases/download/v4.45.2/v2ray-linux-64.zip -o v2ray.zip
# curl -L https://github.com/v2fly/v2ray-core/releases/download/v4.31.0/v2ray-linux-64.zip -o v2ray.zip
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
cat <<EOF > /usr/local/etc/v2ray/config.json
{
  "log": {
    "access": "",
    "error": "",
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "tag": "socks",
      "port": 10808,
      "listen": "127.0.0.1",
      "protocol": "socks",
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      },
      "settings": {
        "auth": "noauth",
        "udp": true,
        "allowTransparent": false
      }
    },
    {
      "tag": "http",
      "port": 10809,
      "listen": "127.0.0.1",
      "protocol": "http",
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      },
      "settings": {
        "auth": "noauth",
        "udp": true,
        "allowTransparent": false
      }
    }
  ],
  "outbounds": [
    {
      "tag": "proxy",
      "protocol": "vmess",
      "settings": {
        "vnext": [
          {
            "address": "185.141.107.62",
            "port": 9009,
            "users": [
              {
                "id": "70c12e91-2faa-485b-a15e-906b1da76518",
                "alterId": 0,
                "email": "t@t.tt",
                "security": "auto"
              }
            ]
          }
        ]
      },
      "streamSettings": {
        "network": "tcp"
      },
      "mux": {
        "enabled": false,
        "concurrency": -1
      }
    },
    {
      "tag": "direct",
      "protocol": "freedom",
      "settings": {}
    },
    {
      "tag": "block",
      "protocol": "blackhole",
      "settings": {
        "response": {
          "type": "http"
        }
      }
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
}
EOF

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


cat <<EOF > /usr/local/etc/v2ray/config.json
{
  "log": {
    "access": "",
    "error": "",
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "tag": "socks",
      "port": 10808,
      "listen": "127.0.0.1",
      "protocol": "socks",
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      },
      "settings": {
        "auth": "noauth",
        "udp": true,
        "allowTransparent": false
      }
    },
    {
      "tag": "http",
      "port": 10809,
      "listen": "127.0.0.1",
      "protocol": "http",
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      },
      "settings": {
        "auth": "noauth",
        "udp": true,
        "allowTransparent": false
      }
    }
  ],
  "outbounds": [
    {
      "tag": "proxy",
      "protocol": "vmess",
      "settings": {
        "vnext": [
          {
            "address": "185.141.107.62",
            "port": 9009,
            "users": [
              {
                "id": "70c12e91-2faa-485b-a15e-906b1da76518",
                "alterId": 0,
                "email": "t@t.tt",
                "security": "auto"
              }
            ]
          }
        ]
      },
      "streamSettings": {
        "network": "tcp"
      },
      "mux": {
        "enabled": false,
        "concurrency": -1
      }
    },
    {
      "tag": "direct",
      "protocol": "freedom",
      "settings": {}
    },
    {
      "tag": "block",
      "protocol": "blackhole",
      "settings": {
        "response": {
          "type": "http"
        }
      }
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
}
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
systemctl status v2ray

cd /tmp/
rm -rf ./v2ray

echo -e "all_proxy=http://127.0.0.1:10809" | sudo tee -a /etc/environment
source /etc/environment

echo "Done"