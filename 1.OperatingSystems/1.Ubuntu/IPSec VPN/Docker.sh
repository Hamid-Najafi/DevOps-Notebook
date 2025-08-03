# -------==========-------
# Docker-Compose
# -------==========-------
#https://hub.docker.com/r/hwdsl2/ipsec-vpn-server
# -------==========-------
sudo git clone https://github.com/Hamid-Najafi/DevOps-Notebook.git
mkdir -p ~/docker/ipsec-vpn 
cp ~/DevOps-Notebook/Apps/IPSec\ VPN/docker-ipsec-vpn-server-master/* ~/docker/ipsec-vpn 
cd ~/docker/ipsec-vpn
# Add new user if needed
nano vpn.env
docker compose up -d

# -------==========-------
# Ubuntu IPSec VPN Cleint 
# -------==========-------
# Add new connection
# sudo add-apt-repository universe
# sudo apt update

sudo apt-get update
sudo apt-get install strongswan xl2tpd net-tools

# Create VPN variables
export VPN_SERVER_IP='91.198.77.165'
export VPN_IPSEC_PSK='123456789'
export VPN_USER='admin'
export VPN_PASSWORD='admin'

# Configure strongSwan
cat > /etc/ipsec.conf <<EOF
# ipsec.conf - strongSwan IPsec configuration file

conn myvpn
  auto=add
  keyexchange=ikev1
  authby=secret
  type=transport
  left=%defaultroute
  leftprotoport=17/1701
  rightprotoport=17/1701
  right=$VPN_SERVER_IP
  ike=aes128-sha1-modp2048
  esp=aes128-sha1
EOF

cat > /etc/ipsec.secrets <<EOF
: PSK "$VPN_IPSEC_PSK"
EOF

chmod 600 /etc/ipsec.secrets

# Configure xl2tpd
cat > /etc/xl2tpd/xl2tpd.conf <<EOF
[lac myvpn]
lns = $VPN_SERVER_IP
ppp debug = yes
pppoptfile = /etc/ppp/options.l2tpd.client
length bit = yes
EOF

cat > /etc/ppp/options.l2tpd.client <<EOF
ipcp-accept-local
ipcp-accept-remote
refuse-eap
require-chap
noccp
noauth
mtu 1280
mru 1280
noipdefault
defaultroute
usepeerdns
connect-delay 5000
name "$VPN_USER"
password "$VPN_PASSWORD"
EOF

chmod 600 /etc/ppp/options.l2tpd.client

# Create xl2tpd control file:
mkdir -p /var/run/xl2tpd
touch /var/run/xl2tpd/l2tp-control

# Restart services:
service strongswan restart
# For Ubuntu 20.04, if strongswan service not found
ipsec restart
service xl2tpd restart

# Start the IPsec connection:
ipsec up myvpn

# Start the L2TP connection:
echo "c myvpn" > /var/run/xl2tpd/l2tp-control

nmcli connection add connection.id NLVPN con-name NLVPN type VPN vpn-type l2tp ifname -- connection.autoconnect no ipv4.method auto vpn.data "gateway = 91.198.77.165, ipsec-enabled = yes, ipsec-psk = 0s"$(base64 <<<'[PSK]' | rev | cut -c2- | rev)"=, mru = 1400, mtu = 1400, password-flags = 0, refuse-chap = yes, refuse-mschap = yes, refuse-pap = yes, require-mppe = yes, user = admin" vpn.secrets password=admin
nmcli connection add connection.id NLVPN con-name NLVPN type VPN vpn-type l2tp ifname -- connection.autoconnect no ipv4.method auto vpn.data "gateway = 91.198.77.165, ipsec-enabled = no, ipsec-psk = 0s"$(base64 <<<'[PSK]' | rev | cut -c2- | rev)"=, mru = 1400, mtu = 1400, password-flags = 0, refuse-chap = yes, refuse-mschap = yes, refuse-pap = yes, require-mppe = yes, user = admin" vpn.secrets password=admin

nmcli connection add connection.id [vpnName] con-name [vpnName] type VPN vpn-type l2tp ifname -- connection.autoconnect no ipv4.method auto vpn.data "gateway = [ipv4], ipsec-enabled = yes, ipsec-psk = 0s"$(base64 <<<'[PSK]' | rev | cut -c2- | rev)"=, mru = 1400, mtu = 1400, password-flags = 0, refuse-chap = yes, refuse-mschap = yes, refuse-pap = yes, require-mppe = yes, user = [user]" vpn.secrets password=[user-password]
- [vpnName] = The name of your connection
- [ipv4] = ip of the l2tp/ipsec server
- [PSK] = pre shared key from the l2tp/ipsec server
- [user] = user name to connect to
- [user-password] = password of the user to connect

To show generated file: nmcli c show id [vpnName]
To start the VPN from cli: nmcli c up [vpnName]
To stop the VPN from cli: nmcli c down [vpnName]

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
# Template hamid-najafi VPN Con.
# -------==========-------
[connection]
id=hamid-najafi
uuid=41347005-0cbe-4227-bf4a-21c94fa9df2b
type=vpn
autoconnect=true
permissions=user:ubuntu:;
timestamp=1596564820

[vpn]
gateway=su.hamid-najafi.ir
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
# Template hamid-najafi VPN Con.
# -------==========-------

[connection]
id=serverius
uuid=ed425ac1-9e1e-452f-bc15-94dedc955c77
type=vpn
autoconnect=false
interface-name=--ens160
permissions=

[vpn]
gateway=su.hamid-najafi.ir
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