# -------==========-------
# OpenVPN RAW
# -------==========-------
mkdir -p ~/dev/openvpn
cd ~/dev/openvpn
curl -O https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
sudo chmod +x openvpn-install.sh
sudo bash openvpn-install.sh
# OVPN Files
/home/c1tech/USERNAME.ovpn.

# -------==========-------
# OpenVPN Docker Compose
# -------==========-------
# https://github.com/dockovpn/dockovpn
# Clone OpenVPN Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/1.OperatingSystems/1.Ubuntu/OpenVPN ~/docker/openvpn
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
# OpenVPN Docker
# -------==========-------
# https://hub.docker.com/r/kylemanna/openvpn/
# https://github.com/kylemanna/docker-openvpn
# -------==========-------
echo -e "OVPN_DATA="ovpn-data"" | sudo tee -a /etc/environment
source /etc/environment
docker volume create --name $OVPN_DATA
docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm kylemanna/openvpn ovpn_genconfig -u udp://91.198.77.165

# passphrase : 1234
docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm -it kylemanna/openvpn ovpn_initpki
docker run -v $OVPN_DATA:/etc/openvpn -d -p 1194:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn

# New Client: Generate a client certificate without a passphrase
docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm -it kylemanna/openvpn easyrsa build-client-full OpenVPNUser nopass
# Retrieve the client configuration with embedded certificates
mkdir ~/OpenVPN
docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm kylemanna/openvpn ovpn_getclient OpenVPNUser > ~/OpenVPN/OpenVPNUser.ovpn
# Download client configuratio to host
scp ubuntu@hamid-najafi.ir:~/OpenVPN/OpenVPNUser.ovpn /Users/hamid/Development/Software/DevOps-Notebook/Apps/OpenVPN/Serverius
scp ubuntu@ir.hamid-najafi.ir:~/OpenVPN/OpenVPNUser.ovpn ./OpenVPNUser-ir.ovpn
scp root@91.198.77.165:~/OpenVPN/OpenVPNUser.ovpn ./OpenVPNUser-NL.ovpn