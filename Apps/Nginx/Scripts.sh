# -------==========------- 
# Nginx
# -------==========------- 
# Install Nginx
sudo apt-get update
sudo apt-get install nginx  -y 

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

# -------==========------- 
# Nginx with RTMP
# -------==========------- 
# 1.Install module nginx-plus
# apt-get install nginx-plus-module-rtmp
# 2.Build module
# Install the Build Tools & Dependencies
sudo apt update
sudo apt install build-essential libpcre3 libpcre3-dev libssl-dev zlib1g-dev
# Compiling NGINX with the RTMP Module
cd /path/to/build/dir
git clone https://github.com/arut/nginx-rtmp-module.git
git clone https://github.com/nginx/nginx.git
cd nginx
# Simple build
./auto/configure --add-module=../nginx-rtmp-module
# Full build
mkdir /var/cache/nginx/client_temp -p
./auto/configure --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log \
--pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx \
--with-http_ssl_module --with-http_realip_module --with-http_gunzip_module --with-http_gzip_static_module --with-threads --with-file-aio --with-http_v2_module \
--with-cc-opt='-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m64 -mtune=native' \
--add-module=../nginx-rtmp-module
# --add-module=../ngx_cache_purge-2.3 --add-module=../headers-more-nginx-module-0.29 --with-http_realip_module --add-module=../ngx_pagespeed-release-1.9.32.10-beta

make -j 8 
# last line is make[1]: Leaving directory '/root/nginx-rtmp/nginx'
sudo make install
sudo adduser --system --no-create-home --shell /bin/false --group --disabled-login nginx

# RTMP
rm /etc/nginx/nginx.conf
nano /etc/nginx/nginx.conf
# Paste rtmp-hls-dash here
# Set Workers
mkdir -p /usr/local/nginx/html/stream/hls
mkdir -p /var/www/html/recordings
chown -R www-data:www-data /var/www/html/recordings/

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

# ----- URLS ----- 
# RTMP Server
rtmp://conf.legace.ir/stream
# Stream Key
livestream
# HLS
https://conf.legace.ir/hls/livestream.m3u8
# DASH
https://conf.legace.ir/dash/livestream.mpd

# ----- Arvan URLS ----- 
rtmp://push.ir-thr-mn-cluster.arvanlive.com:1935/DQOWwvMj5Z
nKABonWQoG

https://legace.arvanlive.com/dash/live/live.mpd
https://legace.arvanlive.com/dash/live/live.mpd

# ----- HLS URLS ----- 
https://bitmovin-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8
edge.flowplayer.org/playful.m3u8
# ----- DASH Test URLS ----- 
https://s3.amazonaws.com/_bc_dml/example-content/sintel_dash/sintel_vod.mpd
https://bitmovin-a.akamaihd.net/content/MI201109210084_1/mpds/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.mpd

# -------==========------- 
# FFMPEG Test
# -------==========------- 
sudo add-apt-repository ppa:mc3man/trusty-media
sudo apt-get update
sudo apt-get install ffmpeg

# Test RMTP
ffmpeg -re -i video2.mp4 -vcodec libx264 -profile:v main -preset:v medium -r 30 -g 60 -keyint_min 60 -sc_threshold 0 -b:v 2500k -maxrate 2500k -bufsize 2500k  -sws_flags lanczos+accurate_rnd -c:a aac -strict -2 -b:a 200k -ar 48000 -ac 2 -acodec copy -f flv rtmp://conf.legace.ir/stream/livestream
ffmpeg -re -i video2.mp4 -vcodec libx264 -profile:v main -preset:v medium -r 30 -g 60 -c:a aac -b:a 2048k -strict -2 -acodec copy -f flv rtmp://conf.legace.ir/stream/livestream
ffmpeg -re -i video2.mp4 -vcodec libx264 -c:a aac -strict -2 -acodec copy -b:a 4096k -f flv rtmp://conf.legace.ir/stream/livestream

ffmpeg -hide_banner \
        -re -f lavfi -i "testsrc2=size=1280x720:rate=30" -pix_fmt yuv420p \
        -c:v libx264 -x264opts keyint=30:min-keyint=30:scenecut=-1 \
        -tune zerolatency -profile:v high -preset veryfast -bf 0 -refs 3 \
        -b:v 1400k -bufsize 1400k \
        -utc_timing_url "https://time.akamai.com/?iso" -use_timeline 0 -media_seg_name 'chunk-stream-epresentationIDumber%05dm4s' \
        -init_seg_name 'init-stream1-epresentationIDm4s' \
        -window_size 5  -extra_window_size 10 -remove_at_exit 1 -adaptation_sets "id=0,streams=v id=1,streams=a" -f flv "rtmps://live-upload.instagram.com:443/rtmp/17881751266850137?s_sw=0&s_vt=ig&a=Abz55vJkHUvtXtQz"

# Test with docker
docker run --net="host" --name=ffmpegRmtpTest --restart=always -d \
        jrottenberg/ffmpeg -hide_banner \
        -re -f lavfi -i "testsrc2=size=1280x720:rate=30" -pix_fmt yuv420p \
        -c:v libx264 -x264opts keyint=30:min-keyint=30:scenecut=-1 \
        -tune zerolatency -profile:v high -preset veryfast -bf 0 -refs 3 \
        -b:v 1400k -bufsize 1400k \
        -utc_timing_url "https://time.akamai.com/?iso" -use_timeline 0 -media_seg_name 'chunk-stream-epresentationIDumber%05dm4s' \
        -init_seg_name 'init-stream1-epresentationIDm4s' \
        -window_size 5  -extra_window_size 10 -remove_at_exit 1 -adaptation_sets "id=0,streams=v id=1,streams=a" -f flv rtmp://localhost/stream/livestream

rtmp://conf.legace.ir:1935/stream/livestream
rtmp://push.ir-thr-mn-cluster.arvanlive.com:1935/DQOWwvMj5Z/nKABonWQoG
rtmp://localhost/stream/livestream
rtmp://localhost:1935/stream/hello
rtmps://live-upload.instagram.com:443/rtmp/

# -------==========------- 
# OBS Linux
# -------==========------- 
# FFmpeg is required
sudo add-apt-repository ppa:obsproject/obs-studio
sudo apt update
sudo apt install obs-studio
# sudo snap install obs-studio
obs --startstreaming &
# -------==========------- 
# Other
# -------==========------- 
# To setup authentication
https://github.com/arut/nginx-rtmp-module/issues/1442

# Guide:
https://docs.peer5.com/guides/setting-up-hls-live-streaming-server-using-nginx/

# -------==========------- 
# Monitoring
# -------==========------- 
https://github.com/3m1o/nginx-rtmp-monitoring
./nginx_rtmp_exporter --nginxrtmp.scrape-uri="localhost/stats/"
./nginx_rtmp_exporter --nginxrtmp.scrape-uri="conf.legace.ir/stat"

http://conf.legace.ir/stat.xsl

https://github.com/mauricioabreu/nginx_rtmp_prometheus
pm2, nodejs
ln -s /usr/bin/nodejs /usr/bin/node
sudo npm cache clean -f
sudo npm install -g n
sudo n stable
http://45.149.77.52:9991

https://github.com/spyrothon/rtmp-exporter