4https://itnext.io/automated-delivery-of-asp-net-core-apps-on-on-prem-kubernetes-1d6327ee1454
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
# Set Hostname
# -------==========-------
sudo hostnamectl set-hostname Private-BBB-2
# Usual Ubuntu
sudo nano /etc/hosts  
127.0.0.1  Private-BBB-2
# Cloud-init Ubuntu
sudo nano /etc/cloud/templates/hosts.debian.tmpl
127.0.0.1 Private-BBB-2
127.0.0.1 pb2.legace.ir

sudo reboot
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
curl ipinfo.io
curl ipinfo.io/ip
# -------==========-------
# SSH
# -------==========-------
ssh-keygen
ssh-copy-id username@remote_host
# -------==========-------
# Get port procces id
# -------==========-------
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
ssh username@server-ip -p 22 -D 5555 -C -q -N -f -g
ssh ubuntu@185.235.41.48 -p 22 -D 5555 -C -q -N -f -g
sudo lsof -i -P -n | grep 5555
apt install proxychains && tail -n 2 /etc/proxychains.conf | wc -c | xargs -I {} truncate /etc/proxychains.conf -s -{} && echo -e "socks5 127.0.0.1 5555" | tee -a /etc/proxychains.conf
# Done
proxychains wget https://charts.gitlab.io 
# -------==========-------
# DNS Proxy
# -------==========-------
# Quick Install
apt install resolvconf && echo -e "nameserver 185.51.200.2\nnameserver 178.22.122.100" | tee -a /etc/resolvconf/resolv.conf.d/head && service resolvconf restart
# Manuall Install
sudo apt install resolvconf
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
sudo service resolvconf restart

# -------==========-------
# HTTP Proxy
# -------==========-------
sudo nano  /etc/environment
echo -e "http_proxy=http://admin:Squidpass.24@hr.hamid-najafi.ir:3128/\nhttps_proxy=http://admin:Squidpass.24@hr.hamid-najafi.ir:3128/" | sudo tee -a /etc/environment
source /etc/environment
curl -x http://admin:Squidpass.24@su.legace.ir:3128/ -L http://panel.vir-gol.ir
wget https://charts.gitlab.io 
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
Username: D08-DS17
Password: @epfl4739@
http://172.28.249.20


OS Files
http://185.141.105.194/

# Ubunut 16.04
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


# Ubunut 18.04
# This file describes the network interfaces available on your system
# For more information, see netplan(5).
network:
  ethernets:
          enp3s0f0:
                  addresses:
                          - 185.170.8.250/32
                  nameservers:
                          addresses:
                                  - 185.51.200.2
                                  - 8.8.8.8
                          search: []
                  routes:
                     - to: 0.0.0.0/0
                       via: 172.27.6.125
                       on-link: true
  version: 2
