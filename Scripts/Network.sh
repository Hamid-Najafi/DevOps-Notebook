# -------==========-------
# Docker port check
# -------==========-------
PORT_TO_CHECK=25
docker run -d -p $PORT_TO_CHECK:80 alexwhen/docker-2048
http://DOMAIN:$PORT_TO_CHECK
# -------==========-------
# Netcat Connectivity checks
# -------==========-------
# Online tools
https://pentest-tools.com/network-vulnerability-scanning/tcp-port-scanner-online-nmap#
https://www.yougetsignal.com/tools/open-ports/

sudo apt install -y netcat
# NetCat Server:
# TCP
sudo nc -l -p 80
# UDP
sudo nc -u -l -p 80
# -------==========-------
# Network packets debugging
sudo tcpdump -n port 1194
sudo tcpdump -i eth0 -s 0 -w tcpdump.pcap udp  -n port 1194

# --==========--
# NetCat Client:
# TCP
nc SERVER-IP/DOMAIN 80
nc c1tech.group 80
# UDP
nc -u SERVER-IP/DOMAIN 82
nc -u c1tech.group 636
# -------==========-------
# IP Information
# -------==========-------
echo -e "alias ipinfo='curl api.ipify.org && echo -e ""'" | sudo tee -a ~/.bashrc > /dev/null
curl ipinfo.io/ip
# -------==========-------
# SSH
# -------==========-------
ssh-keygen
ssh-copy-id username@remote_host
# -------==========-------
# Get Port used by PID
# -------==========-------
sudo lsof -i -P -n | grep 80
sudo lsof -i -P -n | grep 443
sudo lsof -i -P -n | grep 554
sudo lsof -i -P -n | grep 9090
sudo lsof -p 15014
# -------==========-------
# DNS Proxy
# -------==========-------
sudo nano /etc/resolv.conf
# OR
sudo apt install resolvconf -y
sudo systemctl enable resolvconf.service --now
sudo nano /etc/resolvconf/resolv.conf.d/head
# 403.online
nameserver 10.202.10.202
nameserver 10.202.10.102
# Shecan Premium Account (https://shecan.ir)
nameserver 185.51.200.1
nameserver 178.22.122.101
# Shecan Free Account
nameserver 185.51.200.2
nameserver 178.22.122.100
# Begzar (https://begzar.ir)
nameserver 185.55.226.26
nameserver 185.55.225.25

nameserver 78.157.42.100
nameserver 78.157.42.101

nameserver 85.15.1.14
nameserver 85.15.1.15
# Test!
ping google.com
# Update resolvconf
sudo resolvconf -u
sudo systemctl restart resolvconf.service
sudo systemctl restart systemd-resolved.service
# Verify DNS Server
resolvectl status
# -------==========-------
# HTTP Proxy
# -------==========-------
export http_proxy=http://172.25.10.8:20172/
export https_proxy=http://172.25.10.8:20172/
echo -e "http_proxy=http://172.25.10.8:20172/" | sudo tee -a /etc/environment && source /etc/environment
curl -x $http_proxy -L http://google.com
curl -x http://admin:Squidpass.24@IPAddr:3128/ -L http://google.com
# -------==========-------
# SSH Proxy
# -------==========-------
# In Iran Server
ssh-keygen -t rsa -b 4096 -C "server@identifier"
cat /root/.ssh/id_rsa.pub
# copy id_rsa and paste here in foreign server
nano ~/.ssh/authorized_keys 
# test ssh worling without password
ssh username@server-ip
ssh ubuntu@185.235.41.48
# If worked, setup ssh proxy
ssh username@server-ip -p 22 -D 5555 -C -q -N -f -gsudo systemctl restart ocserv

ssh ubuntu@185.235.41.48 -p 22 -D 5555 -C -q -N -f -g
sudo lsof -i -P -n | grep 5555
apt install proxychains && tail -n 2 /etc/proxychains.conf | wc -c | xargs -I {} truncate /etc/proxychains.conf -s -{} && echo -e "socks5 127.0.0.1 5555" | tee -a /etc/proxychains.conf
# Done
proxychains wget https://charts.gitlab.io 
# -------==========-------
# SpeedTest
# -------==========-------
curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -

# -------==========-------
# Netplan Static IP
# -------==========-------
# This is the network config written by 'subiquity'
network:
  ethernets:
    ens33:
      dhcp4: false
      addresses: [172.25.10.8/24]
      routes:
         - to: default
           via: 172.25.10.1
      nameservers:
        addresses: [172.25.10.5]
      dhcp6: false
  version: 2

# -------==========-------
# Wifi Station
# -------==========-------
# in system-boot partition: network-config
sudo nano /etc/netplan/50-cloud-init.yaml

version: 2
ethernets:
  eth0:
    dhcp4: true
    optional: true
wifis:
 wlan0:
   dhcp4: true
   optional: true
   access-points:
     "ILMA 903":
       password: "Officepass.24"
     "ZMI_MF885":
       password: "51176915"

sudo netplan apply
sudo netplan --debug apply
# -------==========-------
#  Wifi Access Point
# -------==========-------
# Disable "systemd-resolved"
# 1
sudo systemctl disable systemd-resolved
# 2
echo -e "DNSStubListener=no" | sudo tee -a /etc/systemd/resolved.conf
# OR 
# "systemd-resolved" & "dnsmasq" together mode
# redirect the systemd-resolved to use the localhost as the primary nameserver. 
# This will make sure that all queries are directed to dnsmasq for resolution before hitting the external DNS server
sed -i '1s/^/nameserver 127.0.0.1\r\n/' /etc/resolv.conf 


sudo apt-get -y install hostapd haveged dnsmasq
sudo nano /etc/default/hostapd

# Check if your wifi card support the AP mode:
sudo iw list |grep -i "Supported interface modes:" -A10
# It should print:
# ...
# * AP
# ...

# https://github.com/oblique/create_ap#internet-sharing-from-the-same-wifi-interface
git clone https://github.com/oblique/create_ap
cd create_ap
sudo make install

# HOT Launch
# Internet sharing from the same WiFi interface:
create_ap wlan0 wlan0 MyAccessPoint MyPassPhrase
create_ap wlan0 wlan0 BCM4345 RPIpass.24
# Ethernet connection through your Wifi interface:
create_ap wlan0 eth0 MyAccessPoint MyPassPhrase
create_ap wlan0 eth0 BCM4345 RPIpass.24

# SYSTEMD
# /lib/systemd/system/create_ap.service
sudo nano /etc/create_ap.conf

sudo systemctl enable create_ap
sudo systemctl start create_ap

# IF NAMERESOLUTION PROBLE:
# REMOVE AND MAKE NEW resolv.conf
sudo rm /etc/resolv.conf
# -------==========-------
# 0-1 Network Config
# -------==========-------
PPTP VPN:
Address: 10.30.70.35
Username:
Password:
IPMI/ILO:

OS Files
http://185.141.105.194/
http://185.141.105.194/Linux/ubuntu-18.04.4-server-amd64.iso
http://185.141.105.194/Linux/ubuntu-18.04.5-live-server-amd64.iso