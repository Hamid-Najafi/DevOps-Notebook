# -------==========-------
# OpenVPN Docker Compose
# -------==========-------
# https://github.com/dockovpn/dockovpn
# Clone OpenVPN Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/OpenVPN ~/docker/openvpn
cd ~/docker/openvpn

# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
# docker network create openvpn-network
docker compose up -d


docker run -it --rm --cap-add=NET_ADMIN \
-p 1194:1194/udp -p 8090:8080/tcp \
--name dockovpn alekslitvinenk/openvpn 

# -------==========-------
# OpenVPN
# -------==========-------
mkdir -p ~/dev/openvpn
cd ~/dev/openvpn
curl -O https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
sudo chmod +x openvpn-install.sh
sudo bash openvpn-install.sh
# OVPN Files
/home/c1tech/USERNAME.ovpn.