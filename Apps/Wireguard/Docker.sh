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
# Set Hostname
nano  ~/docker/wireguard/docker-compose.yml
docker-compose up -d
docker logs wireguard -f
# Scan QRCode and make conf file
https://webqr.com
# -------==========-------
# Conf file
# -------==========-------
# Herman
[Interface] 
Address = 10.13.13.2 
PrivateKey = GDm0Y6qT8nc8U8H1go9/6DxoWHc5KQlRheEZlsGYI0k= 
ListenPort = 51820 
DNS = 10.13.13.1 
[Peer] 
PublicKey = HliPtQbC9DIk9bebsTfxR24IdZV5AJVGb08sGSbVM3s= 
Endpoint = hr.hamid-najafi.ir:51820 
AllowedIPs = 0.0.0.0/0
