# -------==========-------
# Pre Install
# -------==========-------
sudo apt update 
sudo apt upgrade -y

# Set Hostname
sudo hostnamectl set-hostname live
echo -e "127.0.0.1 live" | tee -a /etc/hosts

# HTTP Proxy
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo nano /etc/systemd/system/docker.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=http://admin:Squidpass.24@su.hamid-najafi.ir:3128"
Environment="HTTPS_PROXY=http://admin:Squidpass.24@su.hamid-najafi.ir:3128"
Environment="NO_PROXY=localhost,127.0.0.1,docker-registry.example.com,.corp"

sudo systemctl daemon-reload
sudo systemctl restart docker

sudo reboot
# -------==========------- 
# Nginx with RTMP & HLS & DASH
# -------==========------- 
# 1.Install module nginx-plus
# apt-get install nginx-plus-module-rtmp
# 2.Build module
# Install the Build Tools & Dependencies
sudo apt update
sudo apt install build-essential libpcre3-dev libssl-dev zlib1g-dev -y
# Compiling NGINX with the RTMP Module
mkdir ~/dev/nginx-binary -p
cd ~/dev/nginx-binary
git clone https://github.com/arut/nginx-rtmp-module.git
git clone https://github.com/apache/incubator-pagespeed-ngx.git
git clone https://github.com/nginx/nginx.git
wget https://github.com/nginx/nginx/archive/release-1.19.6.tar.gz
cd nginx
# Simple build
  # ./auto/configure --add-module=../nginx-rtmp-module 
# Full build
mkdir /var/cache/nginx/client_temp -p

CFLAGS=-Wno-error ./auto/configure --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log \
--pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx \
--with-http_ssl_module --with-http_realip_module --with-http_gunzip_module --with-http_gzip_static_module --with-threads --with-file-aio --with-http_v2_module \
--with-cc-opt='-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m64 -mtune=native' \
--add-module=../nginx-rtmp-module 

# --add-module=../incubator-pagespeed-ngx
# --add-module=../ngx_cache_purge-2.3 --add-module=../headers-more-nginx-module-0.29 
make -j8
# last line is make[1]: Leaving directory '/root/nginx-rtmp/nginx'
sudo make install
sudo adduser --system --no-create-home --shell /bin/false --group --disabled-login nginx

# add systemd Nginx Service conf
mkdir  /usr/lib/systemd/system/
cat <<EOF > /usr/lib/systemd/system/nginx.service
[Unit]
Description=nginx - high performance web server
Documentation=https://nginx.org/en/docs/
After=network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target
[Service]
Type=forking
PIDFile=/var/run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t -c /etc/nginx/nginx.conf
ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx.conf
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s TERM $MAINPID
[Install]
WantedBy=multi-user.target
EOF

# start Nginx,add systemd Nginx Service
systemctl enable nginx
service nginx start

# Generate SSL
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
sudo /snap/bin/certbot certonly \
    --nginx\
    --email admin@vir-gol.ir \
    --server https://acme-v02.api.letsencrypt.org/directory \
    --agree-tos \
    --domains "live.vir-gol.ir"

sudo /snap/bin/certbot certonly \
    --nginx\
    --email admin@vir-gol.ir \
    --server https://acme-v02.api.letsencrypt.org/directory \
    --agree-tos \
    --domains "liveapi.vir-gol.ir"

# RTMP
mkdir /etc/nginx/logs/
mkdir /opt/data/hls -p
mkdir /opt/data/dash -p
mkdir -p /var/www/html/recordings
chown -R www-data:www-data /var/www/html/recordings/
rm /etc/nginx/nginx.conf
nano /etc/nginx/nginx.conf
# Paste rtmp-hls-dash here
mkdir /etc/nginx/sites-enabled/
mkdir /etc/nginx/sites-available/
sudo nano /etc/nginx/sites-available/reverse-proxy.conf
# Paste reverse-proxy here
sudo ln -s /etc/nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-enabled/
nginx -t && nginx -s reload


# -------==========------- 
# Dotnet
# -------==========------- 

# Install Docker
curl -sSL https://get.docker.com/ | sh
sudo usermod -aG docker $USER
# https://docs.docker.com/compose/install/#install-compose-on-linux-systems
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

docker pull goldenstarc/bigbluebutton-livestreaming

# Install Dotnet 3.1 Runtime
# add the Microsoft package signing key 
wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
# Install the SDK
sudo apt-get update; \
  sudo apt-get install -y apt-transport-https && \
  sudo apt-get update && \
  sudo apt-get install -y dotnet-sdk-3.1

# Clone Repos
sudo git clone https://oauth2:uRiq-GRyEZrdyvaxEknZ@gitlab.com/saleh_prg/streamingservice.git
cd streamingservice

# Makse service
cat <<EOF > /etc/systemd/system/kestrel-livestream.service
[Unit]
Description=.NET Web API for LiveStream in BBB

[Service]
WorkingDirectory=/var/www/webHook
#ExecStart=dotnet run --urls http://localhost:5000/
ExecStart=/usr/bin/dotnet /var/www/streamingservice/streamingservice.dll  --urls http://localhost:5000/
Restart=always
# Restart service after 10 seconds if the dotnet service crashes:
RestartSec=10
KillSignal=SIGINT
SyslogIdentifier=dotnet-livestream
#User=www-data
User=root
Environment=ASPNETCORE_ENVIRONMENT=Production
Environment=DOTNET_PRINT_TELEMETRY_MESSAGE=false

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable kestrel-livestream.service
sudo systemctl start kestrel-livestream.service
sudo systemctl stop kestrel-livestream.service
sudo systemctl status kestrel-livestream.service
sudo journalctl -fu kestrel-livestream.service
systemctl daemon-reload