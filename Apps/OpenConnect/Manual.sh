# -------==========-------
# OpenConnect Server
# -------==========-------
https://www.linuxbabe.com/ubuntu/openconnect-vpn-server-ocserv-ubuntu-20-04-lets-encrypt
https://www.linuxbabe.com/ubuntu/certificate-authentication-openconnect-vpn-server-ocserv
https://www.linuxbabe.com/linux-server/ocserv-vpn-server-apache-nginx-haproxy
# -------==========-------
# Docker-Compose
# -------==========-------
# Setup SSL Let’s Encrypt
sudo apt install certbot -y
sudo certbot certonly --standalone --preferred-challenges http --agree-tos --email admin@hamid-najafi.ir -d hamid-najafi.ir
sudo certbot certonly --standalone --preferred-challenges http --agree-tos --email admin@hamid-najafi.ir -d hr.goldenstarc.ir

mkdir -p ~/docker/ocserv
cp ~/DevOps-Notebook/Apps/OpenConnect/* ~/docker/ocserv
cd ~/docker/ocserv
# Set: server-cert, server-key & default-domain
nano ocserv.conf
docker-compose up -d
# Delete Test User
docker exec -ti ocserv ocpasswd -c /etc/ocserv/ocpasswd -d test
# Add User
docker exec -ti ocserv ocpasswd -c /etc/ocserv/ocpasswd -g "Route,All" admin
ocservpass.24
docker exec -ti ocserv ocpasswd -c /etc/ocserv/ocpasswd -g "Route,All" usr-hamid
docker exec -ti ocserv ocpasswd -c /etc/ocserv/ocpasswd -g "Route,All" usr-moh
docker exec -ti ocserv ocpasswd -c /etc/ocserv/ocpasswd -g "Route,All" usr-parsa
docker exec -ti ocserv ocpasswd -c /etc/ocserv/ocpasswd -g "Route,All" usr-danial
docker exec -ti ocserv ocpasswd -c /etc/ocserv/ocpasswd -g "Route,All" i2rlabs
docker exec -ti ocserv ocpasswd -c /etc/ocserv/ocpasswd -g "Route,All" usr-rezad
docker exec -ti ocserv ocpasswd -c /etc/ocserv/ocpasswd -g "Route,All" usr-abold
docker exec -ti ocserv ocpasswd -c /etc/ocserv/ocpasswd -g "Route,All" usr-101
docker exec -ti ocserv ocpasswd -c /etc/ocserv/ocpasswd -g "Route,All" usr-102
docker exec -ti ocserv ocpasswd -c /etc/ocserv/ocpasswd -g "Route,All" usr-103
docker exec -ti ocserv ocpasswd -c /etc/ocserv/ocpasswd -g "Route,All" usr-104
docker exec -ti ocserv ocpasswd -c /etc/ocserv/ocpasswd -g "Route,All" usr-105

NOTE: image sometimes stops working!  docker restart ocserv 

# -------==========-------
# Service
# -------==========-------
cat > /etc/systemd/system/ocvpn.service << "EOF"
[Unit]
Description=OpenConnect Client
After=network.target
[Service]
Type=simple
# ExecStart=/bin/sh -c 'echo 641200 | openconnect --user=hamidni cuk.dnsfinde.com:1397 --http-auth=Basic  --passwd-on-stdin --servercert pin-sha256:qgYrqhMY2F/Qai+SvtOZRquKqtCa5yaIZXdMQmV/7rY='
# ExecStart=/bin/sh -c 'echo ocservpass.24 | openconnect --user=admin nl.goldenstarc.ir:443 --http-auth=Basic  --passwd-on-stdin --servercert pin-sha256:o0VPSp4XQX06pfQqpj3xHyYSZZn2nvkTME9yWCH3tAc='
ExecStart=/bin/sh -c 'echo 14789633 | openconnect --user=km83576 c2.kmak.us:443 --http-auth=Basic  --passwd-on-stdin'
Restart=on-failure
User=root
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable ocvpn
systemctl start ocvpn
systemctl status ocvpn

# -------==========-------
# Service
# -------==========-------
cat > ~/addOCServUsr.sh << "EOF"
echo -n "Enter Username: "
read varname
docker exec -ti ocserv ocpasswd -c /etc/ocserv/ocpasswd -g "Route,All" $varname
EOF
chmod +x ~/addOCServUsr.sh
./addOCServUsr.sh
# -------==========-------
# Native
# -------==========-------
# # https://dixmata.com/install-openconnect-ubuntu/
# -------==========-------
sudo nano /etc/sysctl.conf
net.ipv4.ip_forward = 1
sudo sudo sysctl -p
sudo apt update
sudo apt install ocserv -y

# Setup SSL Let’s Encrypt
sudo apt install certbot
sudo certbot certonly --standalone --preferred-challenges http --agree-tos --email admin@hamid-najafi.ir -d nl.hamid-najafi.ir

# Configure Install OpenConnect Ubuntu
sudo nano /etc/ocserv/ocserv.conf
auth = "plain[passwd=/etc/ocserv/ocpasswd]"
server-cert = /etc/letsencrypt/live/nl.hamid-najafi.ir/fullchain.pem
server-key = /etc/letsencrypt/live/nl.hamid-najafi.ir/privkey.pem
max-same-clients = 20
tunnel-all-dns = true
ipv4-network = 172.29.10.1
default-domain = nl.hamid-najafi.ir
#route = 10.0.0.0/8
#route = 172.16.0.0/12
#route = 192.168.0.0/16
#route = fd00::/8
route = default
#no-route = 192.168.5.0/255.255.255.0

# Setup Ubuntu Firewall/UFW And Routing...
apt install ufw
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
### NOT COMPLETED... MUST DO THIS STEP FROM GUIDE


# Create OpenConnect VPN Account
sudo ocpasswd -c /etc/ocserv/ocpasswd username
sudo ocpasswd -c /etc/ocserv/ocpasswd ocuser

sudo systemctl restart ocserv
sudo systemctl status ocserv
# -------==========-------
# OpenConnect Client
# -------==========-------
sudo apt update
sudo apt install openconnect -y
echo -e "alias ocn='sudo openconnect --background --user=admin --passwd-on-stdin  nl.hamid-najafi.ir:443 --http-auth=Basic <<< "ocservpass.24"'" | sudo tee -a ~/.bashrc  > /dev/null
echo -e "alias ocf='sudo killall -SIGINT openconnect'" | sudo tee -a ~/.bashrc > /dev/null
echo -e "alias ipinfo='curl ipinfo.io'" | sudo tee -a ~/.bashrc > /dev/null
# Verify
ip route | grep tun0
ipnifo

echo 14789633 | sudo openconnect --background --user=km83576 c2.kmak.us:443 --http-auth=Basic  --passwd-on-stdin
echo ocservpass.24 | sudo openconnect --background --user=admin hr.goldenstarc.ir:443 --http-auth=Basic  --passwd-on-stdin