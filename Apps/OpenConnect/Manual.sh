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
sudo certbot certonly --standalone --preferred-challenges http --agree-tos --email admin@hamid-najafi.ir -d ir1.goldenstarc.ir
# sudo git clone https://github.com/Hamid-Najafi/DevOps-Notebook.git

mkdir -p ~/docker/ocserv
cp ~/DevOps-Notebook/Apps/OpenConnect/* ~/docker/ocserv
cd ~/docker/ocserv
# Set: server-cert, server-key & default-domain
# nano ocserv.conf
# SETUP HAPROXY FIRST!
cp ocserv-haproxy.conf ocserv.conf
docker-compose up -d

# List Users
docker exec -ti ocserv cat /etc/ocserv/ocpasswd
# Delete Test User
docker exec -ti ocserv ocpasswd -c /etc/ocserv/ocpasswd -d test
# Add User
docker exec -ti ocserv ocpasswd -c /etc/ocserv/ocpasswd -g "Route,All" admin
ocservpass.24
# -------==========-------
# User Manager
# -------==========-------
./rmoveOCServUsr.sh
./removeOCServUsr.sh
./listOCServUsr.sh

cat > ~/addOCServUsr.sh << "EOF"
echo -n "Enter Username: "
read varname
docker exec -ti ocserv ocpasswd -c /etc/ocserv/ocpasswd -g "Route,All" $varname
EOF
chmod +x ~/addOCServUsr.sh

cat > ~/removeOCServUsr.sh << "EOF"
echo -n "Enter Username: "
read varname
docker exec -ti ocserv ocpasswd -c /etc/ocserv/ocpasswd -d $varname
EOF
chmod +x ~/removeOCServUsr.sh

cat > ~/listOCServUsr.sh << "EOF"
docker exec -ti ocserv cat /etc/ocserv/ocpasswd
EOF
chmod +x ~/listOCServUsr.sh
# -------==========-------
# Route Incoming Traffic to another server
# -------==========-------
Run Chain-RouteAllData Script
# -------==========-------
# Service Client
# -------==========-------
sudo apt update && sudo apt install openconnect -y
cat > /etc/systemd/system/ocvpn.service << "EOF"
[Unit]
Description=OpenConnect Client
After=network.target
[Service]
Type=simple
ExecStartPre=/bin/sh -c '/root/preOCScript.sh'
ExecStart=/bin/sh -c 'echo 247600 | openconnect --user=hamidni cuk.dnsfinde.com:1397 --http-auth=Basic  --passwd-on-stdin --servercert pin-sha256:qgYrqhMY2F/Qai+SvtOZRquKqtCa5yaIZXdMQmV/7rY='
# ExecStart=/bin/sh -c 'echo 14789633 | openconnect --user=km83576 c2.kmak.us:443 --http-auth=Basic  --passwd-on-stdin'
# ExecStart=/bin/sh -c 'echo ocservpass.24 | openconnect --user=admin nl.goldenstarc.ir:443 --http-auth=Basic  --passwd-on-stdin --servercert pin-sha256:o0VPSp4XQX06pfQqpj3xHyYSZZn2nvkTME9yWCH3tAc='
Restart=always
User=root
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable ocvpn
sudo systemctl start ocvpn
sudo systemctl status ocvpn

sudo journalctl -u ocvpn.service -f

echo -e "alias ocf='sudo killall -SIGINT openconnect ""'" | sudo tee -a ~/.bashrc > /dev/null
echo -e "alias ipinfo='curl api.ipify.org && echo -e ""'" | sudo tee -a ~/.bashrc > /dev/null

journalctl --vacuum-time=1d

# ==== Directly Connected Gateway ONLY ====
cat >/root/preOCScript.sh << "EOF"
# THIS MUST BE HARD CODED
ip route add default via 172.27.7.57 dev eno1 proto static onlink

vpnServer=cuk.dnsfinde.com
vpnServerIP=$(dig +short $vpnServer -t a)
DefaultGateway=$(ip route | grep default | awk '{print $3;exit}')
Interface=$(ip route | grep default | awk '{print $5;exit}')
# ip route add <VPN server IP address> via <Default Gateway>
ip route add $vpnServerIP via $DefaultGateway dev $Interface onlink

# Not-Needed
# ip route delete default via $DefaultGateway
# ip route add default dev tun0
EOF
chmod +x /root/preOCScript.sh
# -------==========-------
# Bash Client
# -------==========-------
sudo apt update && sudo apt install openconnect -y
echo -e "alias ocn='sudo openconnect --background --user=usr-hamid --passwd-on-stdin  goldenstarc.ir:443 --http-auth=Basic <<< "hamid" > /dev/null'" | sudo tee -a ~/.bashrc  > /dev/null
echo -e "alias ocf='sudo killall -SIGINT openconnect'" | sudo tee -a ~/.bashrc > /dev/null
echo -e "alias ipinfo='curl api.ipify.org && echo -e ""'" | sudo tee -a ~/.bashrc > /dev/null

echo 14789633 | sudo openconnect --background --user=km83576 c2.kmak.us:443 --http-auth=Basic  --passwd-on-stdin
echo 14789633 | sudo openconnect --background --user=km83576 cp6.kmak.info:443 --http-auth=Basic  --passwd-on-stdin
echo 247600 | sudo openconnect --background --user=hamidni cuk.dnsfinde.com:1397 --http-auth=Basic  --passwd-on-stdin --servercert pin-sha256:qgYrqhMY2F/Qai+SvtOZRquKqtCa5yaIZXdMQmV/7rY=
echo hamid | sudo openconnect --background --user=usr-hamid goldenstarc.ir:443 --http-auth=Basic  --passwd-on-stdin

