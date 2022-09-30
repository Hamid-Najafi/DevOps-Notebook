# -------==========-------
# RouteAllData
# -------==========------
# https://medium.com/@blackrobot666/for-iranian-protests-how-to-setup-vpn-proxy-chains-to-bypass-internet-blockade-e8daa13844e2
# -------==========-------
# ip route add default via 188.121.104.1 dev eth0 proto dhcp src 188.121.105.146 metric 100 
ip route add default dev tun0 scope link

# IranServer
sudo su
apt update
apt install jq -y
ip route
# default via 188.121.104.1 dev eth0 proto dhcp src 188.121.105.146 metric 100 
# 169.254.169.254 via 188.121.104.10 dev eth0 proto dhcp src 188.121.105.146 metric 100 
# 188.121.104.0/22 dev eth0 proto kernel scope link src 188.121.105.146 

wget https://raw.githubusercontent.com/Hamid-Najafi/iran_ip_ranges/master/iran_ip_range.json
for range in $(jq .[] ./iran_ip_range.json | sed 's/"//g' | xargs); do
  ip route add $range via 188.121.104.1;
done;
ip route del default via 188.121.104.1
echo -e "alias ocn='sudo openconnect --background --user=admin --passwd-on-stdin  nl.hamid-najafi.ir:443 --http-auth=Basic <<< "ocservpass.24"'" | sudo tee -a ~/.bashrc  > /dev/null
echo -e "alias ocf='sudo killall -SIGINT openconnect'" | sudo tee -a ~/.bashrc > /dev/null
echo -e "alias ipinfo='curl ipinfo.io'" | sudo tee -a ~/.bashrc > /dev/null
# Verify
ip route | grep tun0
ipnifo

sysctl -w net.ipv4.ip_forward=1
iptables -A FORWARD -j ACCEPT
iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE

# Europe Server