https://itnext.io/automated-delivery-of-asp-net-core-apps-on-on-prem-kubernetes-1d6327ee1454
# -------==========-------
# Used ports
# -------==========-------
# Make sure all servers are reachable in internal network
FTP: 21
SSH: 22
HTTP/HTTPS: 80,443
HTTP Proxy: 8080
Squid-HTTP: 3128
LDAP: 389,636
Mail: 25 (SMTP),110,143,587 (SMTP),465 (SMTP),995 (POP3),993 (IMAP),4190
BigBlueButton: 80, 443, 16384 - 32768 (UDP)
CoTurn server: 3478, 49152-65535 (UDP)
Mysql: 3306
Postgres: 5432
SQLServer: 1433
MongoDB: 27017
Outline: 9090 (prometheus), 9091 (exporter), 11471, 53931 (TCP & UDP)
payanak: 5000
lms: 5001
matrix: 8008
adminer: 8080
pgadmin4: 8081
phpmyadmin: 8082
phpldapadmin: 8083
roundcubemail: 8084
riot: 8085 
moodle: 8086
gitlab: 8087, 2222
prometheus: 9090
Grafana:3000
MinIO: 9000


Usual Services:
TCP     21          FTP
TCP     22          SSH
TCP     80          HTTP
TCP     443         HTTPS
TCP     8080        HTTP Proxy
TCP     3128        Squid-HTTP
LDAP:
TCP     389         LDAP
TCP     636         LDAPS
Mail Provider:
TCP     25          SMTP
TCP     110         SSH
TCP     143         SSH
TCP     587         SMTP
TCP     465         SMTP
TCP     995         POP3
TCP     993         IMAP
TCP     4190        SSH
BigBlueButton:
TCP     80          HTTP
TCP     443         HTTPS
UDP     16384-32768 FreeSWITCH/HTML5 RTP
TCP     49152-65535 coturn to connect
CoTurn server:
TCP     3478        Coturn listening
TCP     443        	TLS listening
UDP     49152-65535 Relay ports 
Databases:
TCP     1433        SQLServer
TCP     3478        Mysql
TCP     5432        Postgres
TCP     27017        MongoDB
Kubernetes cluster:
- Master node(s):
TCP     6443*       Kubernetes API Server
TCP     2379-2380   etcd server client API
TCP     10250       Kubelet API
TCP     10251       kube-scheduler
TCP     10252       kube-controller-manager
TCP     10255       Read-Only Kubelet API
- Worker nodes (minions):
TCP     10250       Kubelet API
TCP     10255       Read-Only Kubelet API
TCP     30000-32767 NodePort Services
# -------==========-------
# Docker port check
# -------==========-------
docker run -d -p 8080:80 alexwhen/docker-2048
docker run -d -p 636:80 alexwhen/docker-2048
# -------==========-------
# Netcat port check
# -------==========-------
# Online tools
https://pentest-tools.com/network-vulnerability-scanning/tcp-port-scanner-online-nmap#
https://www.yougetsignal.com/tools/open-ports/

sudo apt-get install netcat
# NetCat Server:
# TCP
sudo nc -l -p 80
sudo nc -l -p 5433
# UDP
sudo nc -u -l -p 80
# NetCat Client:
# TCP
nc phpldapadmin-dei.vir-gol.ir 80
nc 10.69.78.21 82
nc ib2.vir-gol.ir 389
nc vir-gol.ir 5433
# UDP
nc -u 10.69.78.21 82
nc -u vir-gol.ir 636
# -------==========-------
# IP Information
# -------==========-------
echo -e "alias ipinfo='curl api.ipify.org && echo -e ""'" | sudo tee -a ~/.bashrc > /dev/null
curl ipinfo.io
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
# SSH Proxy (the best)
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
# DNS Proxy
# -------==========-------
# Quick Install
sudo nano  /etc/resolv.conf
nameserver 194.104.158.182

nameserver 185.51.200.2
nameserver 178.22.122.100
# OR
sudo apt install resolvconf && echo -e "nameserver 185.51.200.2\nnameserver 178.22.122.100" | tee -a /etc/resolvconf/resolv.conf.d/head && service resolvconf restart
https://virgool.io/@mahdi.ft/dnsredirection-qxrl6fuqc7hv
# Verify DNS Server
systemd-resolve --status

# Manuall Install
sudo apt install resolvconf -y
sudo nano /etc/resolvconf/resolv.conf.d/head
# Cloudflare
nameserver 1.1.1.1
nameserver 1.0.0.1
# Google
nameserver 8.8.8.8
nameserver 4.2.2.4
# Shecan (https://shecan.ir)
nameserver 185.51.200.2
nameserver 178.22.122.100
# Begzar (https://begzar.ir)
nameserver 185.55.225.25
nameserver 185.55.225.26

DNS Server1:
199.85.126.20
199.85.127.20

DNS Server2:
178.22.122.100
94.232.174.194

DNS Server3:
209.244.0.3
209.244.0.4

DNS Server4:
84.200.69.80
84.200.70.40

DNS Server5:
8.26.56.26
8.20.247.20

sudo service resolvconf restart
# -------==========-------
# Docker Registry
# -------==========-------
cat > /etc/docker/daemon.json <<EOF
{
  "registry-mirrors": ["https://registry.docker.ir"]
}
EOF
sudo systemctl restart docker
# -------==========-------
# HTTP Proxy
# -------==========-------
sudo nano  /etc/environment
echo -e "http_proxy=http://admin:Squidpass.24@nl.hamid-najafi.ir:3128/\nhttps_proxy=http://admin:Squidpass.24@nl.hamid-najafi.ir:3128/" | sudo tee -a /etc/environment
source /etc/environment
curl -x http://admin:Squidpass.24@nl.hamid-najafi.ir:3128/ -L http://google.com
curl -x http://admin:Squidpass.24@91.198.77.165:3128/ -L http://google.com
curl -x http://91.198.77.165:3128/ -L http://google.com
# -------==========-------
# speedtest:
# -------==========-------
curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -
# -------==========-------
# 0-1 Network Config
# -------==========-------
PPTP VPN:
Address: 10.30.70.35
Username: ilo-01, 0923789091
Password: sefr0yek@il0, eft0923789091


IPMI/ILO:
Network Address: 172.28.251.201
Username: A01-DS16
Password: A01-DS16

OS Files
http://185.141.105.194/
http://185.141.105.194/Linux/ubuntu-18.04.4-server-amd64.iso
http://185.141.105.194/Linux/ubuntu-18.04.5-live-server-amd64.iso
# -------==========-------
# Ubunut 16.04
# -------==========-------
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).
source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto enp3s0f0
iface enp3s0f0 inet static
        address 185.141.106.36
        netmask 255.255.255.255
        broadcast 185.141.106.36
        post-up route add 172.27.32.13 dev enp3s0f0
        post-up route add default gw 172.27.32.13
        pre-down route del 172.27.32.13 dev enp3s0f0
        pre-down route del default gw 172.27.32.13

# -------==========-------
# Ubunut 20.04 - 195.211.44.219
# -------==========-------
sudo nano /etc/netplan/01-netcfg.yaml 

# This file describes the network interfaces available on your system
# For more information, see netplan(5).
network:
  version: 2
  renderer: networkd
  ethernets:
    eno1:
        addresses:
            - 195.211.44.219/32
        nameservers:
             addresses:
                 - 8.8.4.4
        routes:
            - to: 0.0.0.0/0
              via: 172.27.7.57
              on-link: true

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