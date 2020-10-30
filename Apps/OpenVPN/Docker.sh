# -------==========-------
# OpenVPN
# -------==========-------
OVPN_DATA="ovpn-data"
docker volume create --name $OVPN_DATA
docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm kylemanna/openvpn ovpn_genconfig -u udp://su.legace.ir
# passphrase : 1234
docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm -it kylemanna/openvpn ovpn_initpki
docker run -v $OVPN_DATA:/etc/openvpn -d -p 1194:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn
# New Client: Generate a client certificate without a passphrase
docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm -it kylemanna/openvpn easyrsa build-client-full Serverius nopass
docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm -it kylemanna/openvpn easyrsa build-client-full Server-1 nopass
docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm -it kylemanna/openvpn easyrsa build-client-full Server-2 nopass
docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm -it kylemanna/openvpn easyrsa build-client-full Server-3 nopass
# Retrieve the client configuration with embedded certificates
docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm kylemanna/openvpn ovpn_getclient Serverius > Serverius.ovpn
docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm kylemanna/openvpn ovpn_getclient Server-1 > Server-1.ovpn
docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm kylemanna/openvpn ovpn_getclient Server-2 > Server-2.ovpn
docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm kylemanna/openvpn ovpn_getclient Server-3 > Server-3.ovpn
# Download client configuratio to host
scp ubuntu@su.legace.ir:/home/ubuntu/OVPN/Serverius.ovpn .
scp ubuntu@su.legace.ir:/home/ubuntu/OVPN/Server-1.ovpn .
scp ubuntu@su.legace.ir:/home/ubuntu/OVPN/Server-2.ovpn .
scp ubuntu@su.legace.ir:/home/ubuntu/OVPN/Server-3.ovpn .

Server-1 -> 37.156.28.38 
Server-2 -> 37.156.28.37
Server-3 -> 5.202.53.184

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