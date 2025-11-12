# -------==========-------
# UFW Firewall
# -------==========-------

sudo apt update
sudo apt install ufw  -y 

sudo ufw status verbose

sudo ufw allow ssh
sudo ufw allow http
sudo ufw enable

# Harbor
sudo ufw allow from 192.168.1.50 to any port 8080 proto tcp