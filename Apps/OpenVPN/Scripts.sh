# -------==========-------
# OpenVPN
# -------==========-------
wget https://git.io/vpn -O openvpn-install.sh
sudo chmod +x openvpn-install.sh
sudo bash openvpn-install.sh
scp root@nl.hamid-najafi.ir:/root/client.ovpn ./OpenVPNUser-NL.ovpn