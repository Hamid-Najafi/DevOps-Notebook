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