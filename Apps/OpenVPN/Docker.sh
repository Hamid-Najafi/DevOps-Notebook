# -------==========-------
# OpenVPN
# -------==========-------
echo -e "OVPN_DATA="ovpn-data"" | sudo tee -a /etc/environment
source /etc/environment
docker volume create --name $OVPN_DATA
docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm kylemanna/openvpn ovpn_genconfig -u udp://hamid-najafi.ir
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
scp root@nl.hamid-najafi.ir:~/OpenVPN/OpenVPNUser.ovpn ./OpenVPNUser-NL.ovpn
scp ubuntu@ir.hamid-najafi.ir:~/OpenVPN/OpenVPNUser.ovpn ./OpenVPNUser-IR.ovpn

# -------==========-------
# OpenVPN Ubuntu Client
# -------==========-------
# Install OpenVPN Client
sudo apt update
sudo apt install openvpn -y
# Connect to OpenVPN Server
openvpn --config OpenVPNUser.ovpn
# Verify Connection
ip a show tun0