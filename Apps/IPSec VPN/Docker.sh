# -------==========-------
# Docker-Compose
# -------==========-------
sudo git clone https://github.com/Hamid-Najafi/DevOps-Notebook.git
mkdir -p ~/docker/ipsec-vpn 
cp ~/DevOps-Notebook/Apps/IPSec\ VPN/docker-ipsec-vpn-server-master/* ~/docker/ipsec-vpn 
cd ~/docker/ipsec-vpn
# Add new user if needed
# sudo htpasswd -c passwords admin
docker-compose up -d

# -------==========-------
# Docker
# -------==========-------
sudo docker run \
    --name ipsec-vpn-server \
    --env-file ./vpn.env \
    --restart=always \
    -p 500:500/udp \
    -p 4500:4500/udp \
    -d --privileged \
    hwdsl2/ipsec-vpn-server

# -------==========-------
# IPSec VPN
# -------==========-------
# Add new connection
# sudo add-apt-repository universe
# sudo apt update
sudo apt install network-manager-l2tp network-manager-l2tp-gnome
sudo apt-get install -y network-manager-gnome

sudo service network-manager start  

        sudo nmcli connection add connection.id MerakiVPN \
        con-name MerakiVPN type vpn vpn-type l2tp \
        ifname -- connection.autoconnect no \
        ipv4.method auto \
        vpn.data "gateway = 194.5.206.170, ipsec-enabled = yes, ipsec-esp = aes128-sha1, ipsec-ike = 3des-sha1-modp1024,  ipsec-psk = 0s"$(base64 <<<'123456789' | rev | cut -c2- | rev)"= , password-flags = 0, user = Server1" \
        vpn.secrets password=247600

            sudo nmcli connection up MerakiVPN ifname ens160  --ask

sudo nmcli connection add connection.id test3 con-name test3 type VPN vpn-type l2tp ifname -- connection.autoconnect no ipv4.method auto \
vpn.data "gateway = 194.5.206.170, ipsec-enabled = yes, ipsec-psk = 0s"$(base64 <<<'123456789' | rev | cut -c2- | rev)"=, \
mru = 1400, mtu = 1400, password-flags = 0, refuse-chap = yes, refuse-mschap = yes, refuse-pap = yes, require-mppe = yes, user = Server1" \
vpn.secrets password=247600
#

# fill with template below
sudo nano /etc/NetworkManager/system-connections/serverius

sudo service network-manager restart  
sudo touch /etc/NetworkManager/conf.d/10-globally-managed-devices.conf
sudo sed -i 's/^managed=false/managed=true/' /etc/NetworkManager/NetworkManager.conf       
sudo nmcli device set ens160 managed yes
# Fill Connection from tepmlate bellow
# Set network interface metric to 10 (network/interfaces)
auto ens160
iface ens160 inet static
        address 37.156.28.38
        netmask 255.255.254.0
        gateway 37.156.28.1
        dns-nameservers 8.8.8.8
        metric 10
# Set VPN interface metric to 0 (network/interfaces)
nmcli c # (for uuid)
sudo nmcli connection modify uuid c50a4cf6-0ed5-4974-9cc2-224bc3beef49 ipv4.route-metric 0
sudo service network-manager restart  
sudo nmcli c up test2  ifname ens160  --ask  

# check routes
ip route
sudo nmcli c down serverius ifname ens160

alias vpnon="sudo nmcli c up a ifname ens160 --ask"
alias vpnoff="sudo nmcli c off a ifname ens160"
# -------==========-------
# Template Legace VPN Con.
# -------==========-------
[connection]
id=legace
uuid=41347005-0cbe-4227-bf4a-21c94fa9df2b
type=vpn
autoconnect=true
permissions=user:ubuntu:;
timestamp=1596564820

[vpn]
gateway=su.legace.ir
ipsec-enabled=yes
ipsec-psk=0sMTIzNDU2Nzg5
password-flags=1
user=Server1
service-type=org.freedesktop.NetworkManager.l2tp

[ipv4]
dns-search=
method=auto

[ipv6]
addr-gen-mode=stable-privacy
dns-search=
method=auto

[proxy]
# -------==========-------
# Template Legace VPN Con.
# -------==========-------

[connection]
id=serverius
uuid=ed425ac1-9e1e-452f-bc15-94dedc955c77
type=vpn
autoconnect=false
interface-name=--ens160
permissions=

[vpn]
gateway=su.legace.ir
ipsec-enabled=yes
ipsec-psk=0sMTIzNDU2Nzg5Cg==
mru=1400
mtu=1400
password-flags=0
refuse-chap=yes
refuse-mschap=yes
refuse-pap=yes
require-mppe=yes
user=Server1
service-type=org.freedesktop.NetworkManager.l2tp

[ipv4]
dns-search=
method=auto

[ipv6]
addr-gen-mode=stable-privacy
dns-search=
method=auto

[vpn-secrets]
password=247600