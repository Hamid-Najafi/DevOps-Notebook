# -------==========-------
# RouteAllData
# -------==========------
# https://medium.com/@blackrobot666/for-iranian-protests-how-to-setup-vpn-proxy-chains-to-bypass-internet-blockade-e8daa13844e2
# -------==========-------
# IranServer
apt update && apt install jq -y
sysctl -w net.ipv4.ip_forward=1
wget https://raw.githubusercontent.com/Hamid-Najafi/iran_ip_ranges/master/iran_ip_range.json -O /root/iran_ip_range.json 
(sudo echo "@reboot bash /root/configVPNChain.sh") | sudo crontab -
cat > /root/configVPNChain.sh << "EOF"
DEFGATEWAY=$(ip route | grep default | awk '{print $3;exit}')
for range in $(jq .[] /root/iran_ip_range.json | sed 's/"//g' | xargs); do
  ip route add $range via $DEFGATEWAY;
done;
sudo iptables -A FORWARD -j ACCEPT
sudo iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE
EOF
chmod +x /root/configVPNChain.sh
bash /root/configVPNChain.sh

# =======================
# Directly Connected Gateway 
# =======================
apt update && apt install jq -y
sysctl -w net.ipv4.ip_forward=1
wget https://raw.githubusercontent.com/Hamid-Najafi/iran_ip_ranges/master/iran_ip_range.json -O /root/iran_ip_range.json 
(sudo echo "@reboot bash /root/configVPNChain.sh") | sudo crontab -
cat > /root/configVPNChain.sh << "EOF"
DEFGATEWAY=$(ip route | grep default | awk '{print $3;exit}')
INTEFACE=$(ip route | grep default | awk '{print $5;exit}')
for range in $(jq .[] /root/iran_ip_range.json | sed 's/"//g' | xargs); do
  ip route add $range via $DEFGATEWAY dev $INTEFACE onlink;
done;
sudo iptables -A FORWARD -j ACCEPT
sudo iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE
EOF
chmod +x /root/configVPNChain.sh
bash /root/configVPNChain.sh
# =======================

213.176.64.0/18 via 185.141.107.1 dev eth0 
p route add 213.176.64.0/18 via 172.27.7.57  dev eno1 onlink

 ip route add default via 172.27.7.57 onlink

ip link add dummy0 type dummy
ip addr add 172.27.7.20 dev dummy0
ip route add 172.27.7.57/24 dev dummy0
ip route add default via 172.27.7.57 dev dummy0 proto static onlink 


====================
sudo iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE;
sudo iptables -t nat -A POSTROUTING -o tap_default -j MASQUERADE;
sudo iptables -t nat -I POSTROUTING -s 192.168.30.0/24 -o tun0 -j MASQUERADE;
sudo ip route replace table 128 default via 172.27.7.57;

sudo ip rule add from 195.211.44.219/32 table 128;
sudo ip route add table 128 to 195.211.44.219/22 dev eno1;
sudo ip route add table 128 default via 172.27.7.57;


=================================
iptables -I FORWARD -i tun0 -o wg0 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -t nat -I POSTROUTING -o tun0 -j MASQUERADE
ip6tables -I FORWARD -i wg0 -o tun0 -j ACCEPT
ip6tables -I FORWARD -i tun0 -o wg0 -m state --state ESTABLISHED,RELATED -j ACCEPT
ip6tables -t nat -I POSTROUTING -o tun0 -j MASQUERADE

echo "1 braker” >> /etc/iproute2/rt_tables
ip route add 0.0.0.0/0 dev tun0 table braker
ip rule add from 10.6.6.1/24 lookup braker
sysctl -w net.ipv4.conf.all.route_localnet=1