# -------==========-------
# IPSec VPN
# -------==========-------

# -------==========-------
# Docker-Compose
# -------==========-------
sudo git clone https://github.com/Hamid-Najafi/DevOps-Notebook.git
mkdir -p ~/docker/wireguard
cp ~/DevOps-Notebook/Apps/Wireguard/docker-compose.yml ~/docker/wireguard/
cd ~/docker/wireguard 
docker-compose up -d
docker logs wireguard -f
# Scan QRCode and make conf file
https://webqr.com
# -------==========-------
# Conf file
# -------==========-------
# Serverius
[Interface]
PrivateKey = cCpwBIm6fjRTOnvJj3Ds3HYnysPgXiZ+cR9O1dt4Z1c=
ListenPort = 51820
Address = 10.13.13.2/32
DNS = 10.13.13.1

[Peer]
PublicKey = orB4xAXKo48oIV3MceQtROYKmroxMhz8EG9UCb2ulQc=
AllowedIPs = 0.0.0.0/0
Endpoint = su.legace.ir:51820
