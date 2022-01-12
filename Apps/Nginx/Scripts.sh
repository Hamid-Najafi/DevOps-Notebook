# -------==========------- 
# Nginx
# -------==========------- 
# Install Nginx
sudo apt update
sudo apt install nginx -y 

# Uninstall Nginx
# Removes all but config files.
sudo apt-get remove nginx nginx-common
# Removes everything.
sudo apt-get purge nginx nginx-common
# remove dependencies used by nginx which are no longer required.
sudo apt-get autoremove

#  Enable Server Blocks and Restart Nginx
sudo ln -s /etc/nginx/sites-available/test.com /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
# Test the configuration file
nginx -t
# Start nginx in the background
nginx
# Start nginx in the foreground
nginx -g 'daemon off;'
# Reload the config on the go
nginx -t && nginx -s reload
# Kill nginx
nginx -s stop



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
sudo certbot certonly \
    --nginx\
    --email admin@vir-gol.ir \
    --server https://acme-v02.api.letsencrypt.org/directory \
    --agree-tos \
    --domains "live.vir-gol.ir"

# RTMP
mkdir /etc/nginx/logs/
mkdir /opt/data/hls -p
mkdir /opt/data/dash -p
mkdir -p /var/www/html/recordings
chown -R www-data:www-data /var/www/html/recordings/
rm /etc/nginx/nginx.conf
nano /etc/nginx/nginx.conf
# Paste rtmp-hls-dash here
nginx -t && nginx -s reload
# -------==========------- 
# URLS
# -------==========------- 
# RTMP
rtmp://live.vir-gol.ir/stream/livestream
# HLS
https://live.vir-gol.ir/hls/livestream.m3u8
# DASH
https://live.vir-gol.ir/dash/livestream.mpd
# ----- Arvan URLS ----- 
# ----- HLS URLS ----- 
https://bitmovin-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8
edge.flowplayer.org/playful.m3u8
# ----- DASH Test URLS ----- 
https://s3.amazonaws.com/_bc_dml/example-content/sintel_dash/sintel_vod.mpd
https://bitmovin-a.akamaihd.net/content/MI201109210084_1/mpds/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.mpd
# Test
https://www.wowza.com/testplayers
# -------==========------- 
# Test RTMP Push flow
# -------==========------- 
# Native FFMPEG
sudo add-apt-repository ppa:mc3man/trusty-media
sudo apt-get update
sudo apt-get install ffmpeg

ffmpeg -re -i video2.mp4 -vcodec libx264 -profile:v main -preset:v medium -r 30 -g 60 -keyint_min 60 -sc_threshold 0 -b:v 2500k -maxrate 2500k -bufsize 2500k  -sws_flags lanczos+accurate_rnd -c:a aac -strict -2 -b:a 200k -ar 48000 -ac 2 -acodec copy -f flv rtmp://live.vir-gol.ir/stream/livestream
ffmpeg -re -i video2.mp4 -vcodec libx264 -profile:v main -preset:v medium -r 30 -g 60 -c:a aac -b:a 2048k -strict -2 -acodec copy -f flv rtmp://live.vir-gol.ir/stream/livestream
ffmpeg -re -i video2.mp4 -vcodec libx264 -c:a aac -strict -2 -acodec copy -b:a 4096k -f flv rtmp://live.vir-gol.ir/stream/livestream

ffmpeg -hide_banner \
        -re -f lavfi -i "testsrc2=size=1280x720:rate=30" -pix_fmt yuv420p \
        -c:v libx264 -x264opts keyint=30:min-keyint=30:scenecut=-1 \
        -tune zerolatency -profile:v high -preset veryfast -bf 0 -refs 3 \
        -b:v 1400k -bufsize 1400k \
        -utc_timing_url "https://time.akamai.com/?iso" -use_timeline 0 -media_seg_name 'chunk-stream-epresentationIDumber%05dm4s' \
        -init_seg_name 'init-stream1-epresentationIDm4s' \
        -window_size 5  -extra_window_size 10 -remove_at_exit 1 -adaptation_sets "id=0,streams=v id=1,streams=a" -f flv rtmp://live.vir-gol.ir:1935/stream/livestream
# Docker
docker pull jrottenberg/ffmpeg
docker run --net="host" --name=ffmpegRtmpTest --restart=always \
        -d jrottenberg/ffmpeg -hide_banner \
        -re -f lavfi -i "testsrc2=size=1280x720:rate=30" -pix_fmt yuv420p \
        -c:v libx264 -x264opts keyint=30:min-keyint=30:scenecut=-1 \
        -tune zerolatency -profile:v high -preset veryfast -bf 0 -refs 3 \
        -b:v 1400k -bufsize 1400k \
        -utc_timing_url "https://time.akamai.com/?iso" -use_timeline 0 -media_seg_name 'chunk-stream-epresentationIDumber%05dm4s' \
        -init_seg_name 'init-stream1-epresentationIDm4s' \
        -window_size 5  -extra_window_size 10 -remove_at_exit 1 -adaptation_sets "id=0,streams=v id=1,streams=a" -f flv rtmp://localhost/stream/livestream
# OBS Linux Push flow
# FFmpeg is required
sudo add-apt-repository ppa:obsproject/obs-studio
sudo apt update
sudo apt install obs-studio
# sudo snap install obs-studio
obs --startstreaming &
# -------==========------- 
# Monitoring
# -------==========------- 
git clone https://github.com/3m1o/nginx-rtmp-monitoring.git
cd nginx-rtmp-monitoring
cp stat.xsl /etc/nginx/html/
# 1
docker-compose up
# 2
sudo snap install node --classic
npm install pm2@latest -g
npm install
nano config.json
  "rtmp_server_url":"http://live.vir-gol.ir/stat.xml",
  "rtmp_server_stream_url":"rtmp://live.vir-gol.ir/stream/",
  "rtmp_server_control_url":"http://live.vir-gol.ir/control",
  "session_secret_key":"changekjh",
  "username":"admin",
  "password":"monitor@rtmp",

pm2 start server.js
pm2 startup 
pm2 save

https://live.vir-gol.ir/monitor

# Other Monitorting
https://github.com/mauricioabreu/nginx_rtmp_prometheus
pm2, nodejs
ln -s /usr/bin/nodejs /usr/bin/node
sudo npm cache clean -f
sudo npm install -g n
sudo n stable
http://45.149.77.52:9991

https://github.com/spyrothon/rtmp-exporter


# -------==========------- 
# rtmpdump
# -------==========------- 
rtmpdump -r rtmp://live.vir-gol.ir/stream/livestream -o rtmpStream.mp4 -v
rtmpdump -r rtmp://live.vir-gol.ir/stream/livestream -o /dev/null -v

# -------==========------- 
# Other
# -------==========------- 
# To setup authentication
https://github.com/arut/nginx-rtmp-module/issues/1442
# Guide:
https://docs.peer5.com/guides/setting-up-hls-live-streaming-server-using-nginx/
https://www.youtube.com/watch?v=WNrNUl_0ywM
https://pingos.io