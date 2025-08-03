# -------==========-------
# RouteAllData
# -------==========-------


#!/bin/bash
counter=0;
rerun=0;
OPENVPN_PID=0;
if ! /sbin/ifconfig | grep -q 'tun0'; 
 then
 pgrep openvpn && exit 0
 counter=$((counter+1))
 echo "`date +"%H:%M:%S"`conecting...faildes=$counter...ReRun=$rerun">nordvpnlog.txt;
 sudo openvpn /home/ubuntu/tehranServer.ovpn &
 OPENVPN_PID=$!
 echo $OPENVPN_PID;
 sudo iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE;
 sudo iptables -t nat -A POSTROUTING -o tap_default -j MASQUERADE;
 sudo iptables -t nat -I POSTROUTING -s 192.168.30.0/24 -o tun0 -j MASQUERADE;
 else
 sudo iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE;
 sudo iptables -t nat -A POSTROUTING -o tap_default -j MASQUERADE;
 sudo iptables -t nat -I POSTROUTING -s 192.168.30.0/24 -o tun0 -j MASQUERADE;
 sleep 2;
 ping -c1 youtube.com > /dev/null
 if [ $? -eq 0 ]
 then 
 echo ok;
 sleep 2;
 else
 rerun=$((rerun+1))
 sudo pkill openvpn;
 echo “fail”;
 fi
 echo "`date +"%H:%M:%S"`vpn already run...faildes=$counter...ReRun=$rerun">nordvpnlog.txt;
 fi
sudo ip route replace table 128 default via 185.206.92.1;

# -------==========-------

sudo ip rule add from 185.206.95.110/32 table 128;
sudo ip route add table 128 to 185.206.95.110/22 dev eth0;
sudo ip route add table 128 default via 185.206.92.1;