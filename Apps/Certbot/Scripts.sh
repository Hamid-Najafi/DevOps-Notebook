# -------==========-------
# Certbot
# -------==========-------
sudo snap install --classic certbot
# get and install your certificates
sudo certbot --standalone 
sudo certbot --apache
sudo certbot --nginx
#  just get a certificate
sudo certbot certonly --standalone 
sudo certbot certonly --apache
sudo certbot certonly --nginx
# Get Wildcard SSL for *.legace.ir
sudo certbot certonly \
    --manual \
    --preferred-challenges dns \
    --email admin@legace.ir \
    --server https://acme-v02.api.letsencrypt.org/directory \
    --agree-tos \
    --domains "*.legace.ir"
# Next set _acme-challenge DNS Value

# Get  SSL for legace.ir and www.legace.ir
sudo certbot \
    --email admin@legace.ir \
    --server https://acme-v02.api.letsencrypt.org/directory \
    --agree-tos \
    --domains legace.ir -d www.legace.ir
# -------==========-------
# Certbot
# -------==========-------
sudo docker run \
    -it --rm \
    --name certbot \
    -v "/etc/letsencrypt:/etc/letsencrypt" \
    -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
    --restart=always \
    certbot/certbot certonly