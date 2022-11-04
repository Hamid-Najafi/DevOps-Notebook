# -------==========-------
# RouteAllData
# -------==========------
# https://medium.com/@blackrobot666/for-iranian-protests-how-to-setup-vpn-proxy-chains-to-bypass-internet-blockade-e8daa13844e2
# -------==========-------
# IranServer
sudo su
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