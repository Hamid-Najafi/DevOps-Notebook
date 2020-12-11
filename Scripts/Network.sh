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
sudo nc -l -p 389
# UDP
sudo nc -u -l -p 993
# NetCat Client:
# TCP
nc su.legace.ir 389
# UDP
nc -u ap.legace.ir 993
# -------==========-------
# IP Information
# -------==========-------
curl ipinfo.io
curl ipinfo.io/ip
# -------==========-------
# DNS
# -------==========-------
sudo apt install resolvconf
sudo nano /etc/resolvconf/resolv.conf.d/head
# Cloudflare
nameserver 1.1.1.1
nameserver 1.0.0.1
# Google
nameserver 8.8.8.8
nameserver 4.2.2.4
# Shecan
nameserver 185.51.200.2
nameserver 178.22.122.100
# Begzar
#nameserver 185.55.226.2
#nameserver 185.55.225.25
sudo service resolvconf restart
# -------==========-------
# HTTP Proxy
# -------==========-------
echo -e "http_proxy=http://admin:Squidpass.24@su.legace.ir:3128/\nhttps_proxy=http://admin:Squidpass.24@su.legace.ir:3128/\nftp_proxy=http://admin:Squidpass.24@su.legace.ir:3128/" | sudo tee -a /etc/environment
source /etc/environment
curl -x http://admin:Squidpass.24@su.legace.ir:3128/ -L http://lms.legace.ir
wget https://charts.gitlab.io 
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
# speedtest:
# -------==========-------
curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -
