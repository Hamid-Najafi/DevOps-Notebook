# -------==========-------
# Certbot Docker
# -------==========-------
# HTTP (80) based _acme-challenge
sudo docker run \
    -it --rm \
    --name certbot \
    -v "/etc/letsencrypt:/etc/letsencrypt" \
    -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
    certbot/certbot certonly


# -------==========-------
# Certbot Ubuntu
# -------==========-------
sudo apt-get install certbot
sudo apt-get install certbot python3-certbot-nginx
sudo apt-get install certbot python3-certbot-apache 
sudo apt-get purge certbot python3-certbot-apache 

sudo snap install --classic certbot
# get and install your certificates
sudo certbot --standalone
sudo certbot --apache
sudo certbot --nginx
#  just get a certificate
sudo certbot certonly --standalone 
sudo certbot certonly --apache
sudo certbot certonly --nginx

sudo certbot certonly \
    --email admin@hamid-najafi.ir \
    --server https://acme-v02.api.letsencrypt.org/directory \
    --agree-tos \
    --domains ir.hamid-najafi.ir

# DNS based _acme-challenge
sudo certbot certonly \
    --manual \
    --preferred-challenges dns \
    --email admin@vir-gol.ir \
    --server https://acme-v02.api.letsencrypt.org/directory \
    --agree-tos \
    --domains "*.legace.ir"
# -------==========-------
# TIPs
# -------==========-------
https://www.ssllabs.com/ssltest