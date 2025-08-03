# -------==========-------
# Tips
# -------==========-------
cd /var/www/
git clone https://github.com/Hamid-Najafi/hamid-najafi.ir.git

cat <<EOF > /etc/nginx/sites-available/hamid_najafi_ir
server {
  listen 80 default_server;
  listen [::]:80 default_server;
  root /var/www/hamid-najafi.ir;
  index index.html;
  server_name hamid-najafi.ir www.hamid-najafi.ir;
  location / {
    try_files $uri $uri/ =404;
  }
}
EOF

ln -s /etc/nginx/sites-available/hamid_najafi_ir /etc/nginx/sites-enabled/hamid_najafi_ir
nginx -t
systemctl restart nginx

# Certbot
sudo apt-get install certbot python3-certbot-nginx -y
sudo certbot \
    --email admin@hamid-najafi.ir \
    --server https://acme-v02.api.letsencrypt.org/directory \
    --agree-tos \
    --nginx \
    --domains hamid-najafi.ir

 
cat <<EOF > /etc/nginx/sites-available/hamid_najafi_ir
server {
  root /var/www/hamid-najafi.ir;
  index index.html index.htm;
  server_name hamid-najafi.ir;
  location / {
   default_type "text/html";
   try_files $uri.html $uri $uri/ /index.html;
  }
    listen 127.0.0.2:443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/hamid-najafi.ir/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/hamid-najafi.ir/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
}
 server {
    if ($host = hamid-najafi.ir) {
        return 301 https://$host$request_uri;
    } # managed by Certbot
  listen   80;
  server_name hamid-najafi.ir;
    return 404; # managed by Certbot
}
EOF

nginx -t
systemctl restart nginx