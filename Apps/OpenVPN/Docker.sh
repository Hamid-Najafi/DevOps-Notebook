# -------==========-------
# OpenVPN
# -------==========-------
echo -e "OVPN_DATA="ovpn-data"" | sudo tee -a /etc/environment
source /etc/environment
docker volume create --name $OVPN_DATA
docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm kylemanna/openvpn ovpn_genconfig -u udp://su.legace.ir
# passphrase : 1234
docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm -it kylemanna/openvpn ovpn_initpki
docker run -v $OVPN_DATA:/etc/openvpn -d -p 1194:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn
# New Client: Generate a client certificate without a passphrase
docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm -it kylemanna/openvpn easyrsa build-client-full Serverius nopass
docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm -it kylemanna/openvpn easyrsa build-client-full User-1 nopass
docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm -it kylemanna/openvpn easyrsa build-client-full User-2 nopass
docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm -it kylemanna/openvpn easyrsa build-client-full User-3 nopass
# Retrieve the client configuration with embedded certificates
mkdir ~/OpenVPN
docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm kylemanna/openvpn ovpn_getclient Serverius >  ~/OpenVPN/Serverius.ovpn
docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm kylemanna/openvpn ovpn_getclient User-1 >  ~/OpenVPN/User-1.ovpn
docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm kylemanna/openvpn ovpn_getclient User-2 >  ~/OpenVPN/User-2.ovpn
docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm kylemanna/openvpn ovpn_getclient User-3 > ~/OpenVPN/User-3.ovpn
# Download client configuratio to host
scp ubuntu@su.legace.ir:~/OpenVPN/Serverius.ovpn /Users/hamid/Development/Software/DevOps-Notebook/Apps/OpenVPN/Serverius
scp ubuntu@su.legace.ir:~/OpenVPN/User-1.ovpn /Users/hamid/Development/Software/DevOps-Notebook/Apps/OpenVPN/Serverius
scp ubuntu@su.legace.ir:~/OpenVPN/User-2.ovpn /Users/hamid/Development/Software/DevOps-Notebook/Apps/OpenVPN/Serverius
scp ubuntu@su.legace.ir:~/OpenVPN/User-3.ovpn /Users/hamid/Development/Software/DevOps-Notebook/Apps/OpenVPN/Serverius
# -------==========-------
# Ubuntu Client
# -------==========-------
# THIS WILL RUN NGINX ON PORT 80
sudo apt install -y network-manager network-manager-openvpn network-manager-gnome network-manager-openvpn-gnome
# sudo apt remove -y network-manager network-manager-openvpn network-manager-gnome network-manager-openvpn-gnome
sudo service network-manager restart
# -------==========-------
sudo touch /etc/NetworkManager/conf.d/10-globally-managed-devices.conf
sudo sed -i 's/^managed=false/managed=true/' /etc/NetworkManager/NetworkManager.conf
# Check for ethernet interface name
ip a
sudo nmcli device set ens160 managed yes
# Set network interface metric to 10
sudo nano /etc/network/interfaces
auto ens160
iface ens160 inet static
        address 37.156.28.38
        netmask 255.255.254.0
        gateway 37.156.28.1
        dns-nameservers 8.8.8.8
        metric 10
sudo service networking restart
# -------==========-------
sudo nmcli connection import type openvpn file ~/devops-notebook/Apps/OpenVPN/Server-2.ovpn 
nmcli connection show
# Set OpenVPN interface metric to 0
sudo nmcli connection modify Server-3 ipv4.route-metric 20
sudo service network-manager restart
sudo nmcli connection up Server-3
# Check if its ok
curl ipinfo.io/ip
wget https://charts.gitlab.io 
# check routes
ip route
sudo nmcli connection down Server-3
# -------==========-------
# set aliases
alias vpnon="sudo nmcli c up Server-1"
alias vpnoff="sudo nmcli c off Server-1"
# check this for autoconnect & alwaysON
connection.autoconnect