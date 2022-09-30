# -------==========-------
# OpenConnect Server
# -------==========-------
# https://dixmata.com/install-openconnect-ubuntu/
# -------==========-------
# Docker
# -------==========-------
 docker run --name ocserv --privileged -v $PWD/ocpasswd:/etc/ocserv/ocpasswd -p 443:443 -p 443:443/udp -d tommylau/ocserv
# -------==========-------
# Docker-Compose
# -------==========-------
# Setup SSL Let’s Encrypt
sudo apt install certbot
sudo certbot certonly --standalone --preferred-challenges http --agree-tos --email admin@hamid-najafi.ir -d nl.hamid-najafi.ir

mkdir -p ~/docker/ocserv
cp ~/DevOps-Notebook/Apps/OpenConnect/* ~/docker/ocserv
cd ~/docker/ocserv 
docker-compose up -d

# Add new user
docker exec -ti ocserv ocpasswd -c /etc/ocserv/ocpasswd -g "Route,All" admin
# -------==========-------
# Native
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
### NOT COMPLETED... MUST DO THIS STEP


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
echo -e "alias ocn='sudo openconnect --background --user=hamidni --passwd-on-stdin  nl.hamid-najafi.ir:443 --http-auth=Basic --servercert pin-sha256:qgYrqhMY2F/Qai+SvtOZRquKqtCa5yaIZXdMQmV/7rY= <<< "641200"'" | sudo tee -a /etc/environment  > /dev/null
echo -e "alias ocn='sudo openconnect --background --user=hamidni --passwd-on-stdin  nl.hamid-najafi.ir:443 --http-auth=Basic <<< "641200"'" | sudo tee -a /etc/environment  > /dev/null
sudo openconnect --background --user=ocuser --passwd-on-stdin  nl.hamid-najafi.ir:443

echo -e "alias ocf='sudo killall -SIGINT openconnect'" | sudo tee -a /etc/environment > /dev/null
echo -e "alias ipinfo='curl ipinfo.io'" | sudo tee -a /etc/environment > /dev/null
source /etc/environment