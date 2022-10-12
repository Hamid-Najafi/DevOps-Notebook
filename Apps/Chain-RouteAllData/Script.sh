# -------==========-------
# RouteAllData
# -------==========------
# https://medium.com/@blackrobot666/for-iranian-protests-how-to-setup-vpn-proxy-chains-to-bypass-internet-blockade-e8daa13844e2
# -------==========-------
ip route add default via 37.32.20.1 dev eth0 proto dhcp src 37.32.21.73 metric 100 
# ip route add default dev tun0 scope link

# IranServer
sudo su
apt update
apt install jq openconnect -y

# Config IPTables
sysctl -w net.ipv4.ip_forward=1

# Backup IP Routes
ip route
# default via 37.32.20.1 dev eth0 proto dhcp src 37.32.21.73 metric 100 
# 37.32.20.0/22 dev eth0 proto kernel scope link src 37.32.21.73 
# 169.254.169.254 via 37.32.20.10 dev eth0 proto dhcp src 37.32.21.73 metric 100 
# 172.17.0.0/16 dev docker0 proto kernel scope link src 172.17.0.1 linkdown 
# 172.18.0.0/16 dev br-5d26c6f62840 proto kernel scope link src 172.18.0.1 
# 172.19.0.0/16 dev br-ce70e3f59d33 proto kernel scope link src 172.19.0.1 

wget https://raw.githubusercontent.com/Hamid-Najafi/iran_ip_ranges/master/iran_ip_range.json
(sudo echo "@reboot bash /home/ubuntu/configVPNChain.sh") | sudo crontab -
cat > /home/ubuntu/configVPNChain.sh <<EOF
for range in $(jq .[] /home/ubuntu/iran_ip_range.json | sed 's/"//g' | xargs); do
  ip route add $range via 37.32.20.1;
done;
openconnect --background --user=admin --passwd-on-stdin  nl.hamid-najafi.ir:443 --http-auth=Basic <<< "ocservpass.24"
iptables -A FORWARD -j ACCEPT
iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE
EOF
chmod +x /home/ubuntu/configVPNChain.sh
# Set Variables
su ubuntu
echo -e "alias ocn='sudo openconnect --background --user=admin --passwd-on-stdin  nl.hamid-najafi.ir:443 --http-auth=Basic <<< "ocservpass.24"'" | sudo tee -a ~/.bashrc  > /dev/null
echo -e "alias ocf='sudo killall -SIGINT openconnect'" | sudo tee -a ~/.bashrc > /dev/null
echo -e "alias ipinfo='curl ipinfo.io'" | sudo tee -a ~/.bashrc > /dev/null
source  ~/.bashrc
# Coonect 
ocn
# Verify
ip route | grep tun0
ipnifo
sudo reboot
# -------==========------