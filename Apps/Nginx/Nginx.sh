# -------==========------- 
# Nginx
# -------==========------- 
# Install Nginx
sudo apt update
sudo apt install nginx -y 

# Remove Default site 
rm /etc/nginx/sites-available/default
rm /etc/nginx/sites-enabled/default 

# Create NGINX webserver's config files.
sudo nano /etc/nginx/sites-enabled/config_file_name.conf
# PUT CONFIG HERE

# Enable Server Blocks and Restart Nginx
sudo ln -s /etc/nginx/sites-available/test.com /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx

# Certbot
sudo apt-get install certbot python3-certbot-nginx -y
sudo certbot \
    --email admin@hamid-najafi.ir \
    --server https://acme-v02.api.letsencrypt.org/directory \
    --agree-tos \
    --nginx \
    --domains hamid-najafi.ir

# Start nginx in the background
nginx
# Start nginx in the foreground
nginx -g 'daemon off;'
# Reload the config on the go
nginx -t && nginx -s reload
# Kill nginx
nginx -s stop

# -------==========------- 
# Uninstall Nginx
# -------==========------- 
# Removes all but config files.
sudo apt remove -y nginx nginx-common
# Removes everything.
sudo apt purge -y nginx nginx-common
# remove dependencies used by nginx which are no longer required.
sudo apt autoremove