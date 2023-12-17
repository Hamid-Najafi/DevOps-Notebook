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