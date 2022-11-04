# -------==========-------
# RouteAllData
# -------==========------
# https://medium.com/@blackrobot666/for-iranian-protests-how-to-setup-vpn-proxy-chains-to-bypass-internet-blockade-e8daa13844e2
# -------==========-------
# IranServer
sudo su
apt update
apt install jq openconnect -y

# Config IPTables
sysctl -w net.ipv4.ip_forward=1

# Backup IP Routes
ip route
ip route del default via 185.141.107.1 
# default via 185.141.107.1 dev eth0 onlink 
# 172.17.0.0/16 dev docker0 proto kernel scope link src 172.17.0.1 linkdown 
# 185.141.107.0/24 dev eth0 proto kernel scope link src 185.141.107.62 

wget https://raw.githubusercontent.com/Hamid-Najafi/iran_ip_ranges/master/iran_ip_range.json
(sudo echo "@reboot bash /root/configVPNChain.sh") | sudo crontab -

nano  /root/configVPNChain.sh
for range in $(jq .[] /root/iran_ip_range.json | sed 's/"//g' | xargs); do
  ip route add $range via 185.141.107.1;
done;
iptables -A FORWARD -j ACCEPT
iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE

chmod +x /root/configVPNChain.sh
bash /root/configVPNChain.sh
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