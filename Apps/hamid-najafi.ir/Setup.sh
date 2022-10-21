# -------==========-------
# Tips
# -------==========-------
sudo su
cd /var/www/
git clone https://github.com/Hamid-Najafi/hamid-najafi.ir.git

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

ln -s /etc/nginx/sites-available/hamid_najafi_ir /etc/nginx/sites-enabled/hamid_najafi_ir
nginx -t
systemctl restart nginx

# Certbot
sudo apt-get install certbot python3-certbot-nginx -y
sudo certbot certonly --standalone --preferred-challenges http --agree-tos --email admin@hamid-najafi.ir -d hamid-najafi.ir