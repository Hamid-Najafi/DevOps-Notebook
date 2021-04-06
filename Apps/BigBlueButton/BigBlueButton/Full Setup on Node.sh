# REAL BUG:
when someone is speaking its name is shown upside of presentaion. if he/she stop speaking its connection will remain connected for 10 second. with treansported name
after his name will remove.
if he/she speak while his/her name is treansport, there will be lag in sound.

# Docs:
https://docs.bigbluebutton.org/2.2/customize.html

# -------==========-------
# Minimum Req
# -------==========-------
Memory: 4GB
OS: Ubuntu 16 or 18 (64bit)
# -------==========-------
# Pre-install
# -------==========-------
# Set host to use proxy
echo -e "http_proxy=http://admin:Squidpass.24@su.legace.ir:3128/\nhttps_proxy=http://admin:Squidpass.24@su.legace.ir:3128/\nftp_proxy=http://admin:Squidpass.24@su.legace.ir:3128/" | sudo tee -a /etc/environment
echo -e "http_proxy=http://admin:Squidpass.24@eu.legace.ir:3128/\nhttps_proxy=http://admin:Squidpass.24@eu.legace.ir:3128/\nftp_proxy=http://admin:Squidpass.24@eu.legace.ir:3128/" | sudo tee -a /etc/environment
source /etc/environment
curl -x http://admin:Squidpass.24@su.legace.ir:3128/ -L http://panel.vir-gol.ir

# HTTP Proxy
# sudo mkdir -p /etc/systemd/system/docker.service.d
# sudo nano /etc/systemd/system/docker.service.d/http-proxy.conf
# [Service]
# Environment="HTTP_PROXY=http://admin:Squidpass.24@su.legace.ir:3128"
# Environment="HTTPS_PROXY=http://admin:Squidpass.24@su.legace.ir:3128"
# Environment="NO_PROXY=localhost,127.0.0.1,docker-registry.example.com,.corp"

# sudo systemctl daemon-reload
# sudo systemctl restart docker

# DNS Proxy
sudo apt install resolvconf
sudo nano /etc/resolvconf/resolv.conf.d/head
nameserver 185.51.200.2
nameserver 178.22.122.100

sudo service resolvconf restart

# Set Hostname
sudo hostnamectl set-hostname ib2
sudo nano /etc/hosts  
127.0.1.1 ib2

# Ubuntu Automatic Update
sudo nano /etc/update-manager/release-upgrades

sudo reboot
# -------==========-------
# Install
# -------==========-------
# Control+F : change all ib1 to IB*
export fqdnHost=ib2.vir-gol.ir

sudo apt install base-files
#*      Set FQDN Correctly      *#
#* BE AWARE OF SSH PORT FOR FIREWALL *#
# Install latest version 2.3-beta-x
wget -qO- https://ubuntu.bigbluebutton.org/bbb-install.sh | sudo bash -s -- -v bionic-230 -s $fqdnHost -e admin@vir-gol.ir -g -w
 -c turn.vir-gol.ir:1b6s1esK
# Install latest version 2.2.x
wget -qO- https://ubuntu.bigbluebutton.org/bbb-install.sh | sudo bash -s -- -v xenial-22 -s $fqdnHost -e admin@vir-gol.ir -g -w
 -c turn.vir-gol.ir:1b6s1esK
# Install specific version (only for older versions) 
wget -qO- https://ubuntu.bigbluebutton.org/bbb-install.sh | sudo bash -s -- -v xenial-220-2.2.29 -s $fqdnHost -e admin@vir-gol.ir -g -w -c turn.vir-gol.ir:1b6s1esK
wget -qO- https://ubuntu.bigbluebutton.org/bbb-install.sh | sudo bash -s -- -v xenial-220-2.2.27 -s $fqdnHost -e admin@vir-gol.ir -g -w
# http://ubuntu.bigbluebutton.org/xenial-220-2.2.29/dists/bigbluebutton-xenial/Release.gpg
# Install Turn Server
wget -qO- https://ubuntu.bigbluebutton.org/bbb-install.sh | bash -s -- -c turn.vir-gol.ir:1b6s1esK -e admin@vir-gol.ir
# -------==========-------
# Uninstall
# -------==========-------
sudo apt-get purge nodejs mongodb-org  bigbluebutton bbb-* 
# OR
sudo apt-get purge bbb-apps bbb-apps-akka bbb-apps-screenshare bbb-apps-sip bbb-apps-video bbb-apps-video-broadcast bbb-client bbb-etherpad \
bbb-freeswitch-core bbb-freeswitch-sounds bbb-fsesl-akka bbb-mkclean bbb-playback-presentation bbb-record-core bbb-red5 bbb-transcode-akka bbb-web
#sudo apt-get purge apt-transport-https haveged build-essential yq
sudo apt autoremove
sudo ufw disable
# -------==========-------
# Troubleshooting
# -------==========-------
sudo bbb-conf --clean
sudo bbb-conf --check

# -------==========-------
# Set Images
# -------==========-------
git clone https://github.com/Hamid-Najafi/DevOps-Notebook.git
# Virgol
sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Theme/Virgol/favicon.ico /var/www/bigbluebutton-default/favicon.ico
sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Theme/Virgol/Whiteboard.pdf /var/www/bigbluebutton-default/Whiteboard.pdf
sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Theme/Virgol/Whiteboard.pdf /var/www/bigbluebutton-default/Whiteboard-Virgol.pdf
# Dei
sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Theme/Dei/favicon.ico /var/www/bigbluebutton-default/favicon.ico
sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Theme/Dei/Whiteboard.pdf /var/www/bigbluebutton-default/Whiteboard-DEI.pdf
# sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Theme/Dei/Whiteboard.pdf /var/www/bigbluebutton-default/Whiteboard.pdf
# Sampad
sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Theme/Sampad/favicon.ico /var/www/bigbluebutton-default/favicon.ico
sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Theme/Sampad/Whiteboard.pdf /var/www/bigbluebutton-default/Whiteboard-Sampad.pdf
# sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Theme/Sampad/Whiteboard.pdf /var/www/bigbluebutton-default/Whiteboard.pdf

# -------==========-------
# BBB - Configs     
# -------==========-------
sudo mv /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conferenceBackup
export version=2.3.0-beta-2
sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Settings/$version/bigbluebutton.properties /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Settings/$version/settings.yml /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml
sudo bbb-conf --setsecret 1b6s1esKbXNM82ussxx8OHJTenNvfkBu59tkHHADvqk
sudo bbb-conf --setip $fqdnHost
# -------==========-------
# Change Locales 
# -------==========-------
# List
ls /usr/share/meteor/bundle/programs/server/assets/app/locales/
# Set to Arabic
sudo nano /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml
        fallbackLocale: ar
        overrideLocale: ar
sudo nano /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
# -------==========-------
# Install Fonts
# -------==========-------
sudo git clone https://github.com/Hamid-Najafi/FontPack.git  /usr/share/fonts/FontPack
sudo fc-cache -fv
# -------==========-------
# 1. Hostname & Secrets
# -------==========-------
# Dont run setip, use install-script to change FQDN instead.
# sudo bbb-conf --setip b1.vir-gol.ir
# sudo bbb-conf --setsecret 1b6s1esKbXNM82ussxx8OHJTenNvfkBu59tkHHADvqk
# sudo bbb-conf --restart
# -------==========-------
# 2. Demo API
# -------==========-------
sudo apt-get install bbb-demo
sudo apt-get purge bbb-demo
# Secret Location
# Version 2.2
sudo nano /var/lib/tomcat7/webapps/demo/bbb_api_conf.jsp
# Version 2.3
sudo nano /var/lib/tomcat8/webapps/demo/bbb_api_conf.jsp
# -------==========-------
# 3. Setup Greenlight
# -------==========-------
sudo rm /etc/bigbluebutton/nginx/greenlight-redirect.nginx
cd ~/greenlight
sudo nano .env
BIGBLUEBUTTON_SECRET=1b6s1esKbXNM82ussxx8OHJTenNvfkBu59tkHHADvqk
sudo docker run --rm --env-file .env bigbluebutton/greenlight:v2 bundle exec rake conf:check
sudo docker-compose up -d
sudo docker exec greenlight-v2 bundle exec rake user:create["Admin","admin@vir-gol.ir","BBBpass.24","admin"]
# -------==========-------
# 3. Downloadable Recording
# -------==========-------
git clone https://github.com/vova-zush/bbb-download.git ~/bbb-download
cd ~/bbb-download
chmod u+x install.sh 
sudo ./install.sh
# To convert all of your current recordings to MP4 format use command:
sudo bbb-record --rebuildall
sudo bbb-record --list
https://b1.vir-gol.ir/download/presentation/{InternalmeetingID}/{InternalmeetingID}.mp4
# -------==========-------
# 3. Setup Monitoring
# -------==========-------
# BBB Exporter
cp -R ~/DevOps-Notebook/Apps/BigBlueButton/Monitoring/bbb-exporter ~/bbb-exporter 
cd ~/bbb-exporter
# If needed edit secret file
# bbb-conf --secret
sudo nano secrets.env
#*    Set FQDN Correctly     *#
API_BASE_URL=https://$fqdnHost/bigbluebutton/api/
API_SECRET=1b6s1esKbXNM82ussxx8OHJTenNvfkBu59tkHHADvqk

sudo docker-compose up -d
# Add Nginx Auth for exporter
# Username:metrics , Password: monitor@bbb
echo 'admin:$apr1$k98EN1wL$.4puamdnCPS46oGRDvRKx/' | sudo tee /etc/nginx/.htpasswd
# sudo apt install -y apache2-utils
# sudo htpasswd -c /etc/nginx/.htpasswd admin
    # Method 1:
# Replace FQDDN Address
sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Settings/$version/bigbluebutton.nginx /etc/nginx/sites-available/bigbluebutton
    # Method 2:
 (in the last line just before '}' )
sudo nano /etc/nginx/sites-available/bigbluebutton 
  location /metrics/ {
      auth_basic "BigBlueButton Exporter";
      auth_basic_user_file /etc/nginx/.htpasswd;
      proxy_pass http://127.0.0.1:9688/;
      include proxy_params;
  }
  location = / {
    return 301 https://panel.vir-gol.ir/;
  }

# Node Exporter
cp -R ~/DevOps-Notebook/Apps/Monitoring/Slave/ ~/monitoring
cd ~/monitoring
sudo docker-compose up -d
sudo ufw allow 9100
sudo ufw allow 9338
sudo ufw allow 9688
sudo nginx -t && sudo nginx -s reload

# -------==========-------
# Prometheus Montoring
# -------==========-------
# Virgol
cd docker/monitoringLite/
nano prometheus/prometheus.yml
# add server address to 'nodeexporter' , 'cadvisor', and 'bbb' Jobs
docker-compose up -d --force-recreate --no-deps prometheus

# -------==========-------
# Test
# -------==========-------
# Postman or Firefox:
# BBB
https://mconf.github.io/api-mate/#server=https://$fqdnHost/bigbluebutton/&sharedSecret=1b6s1esKbXNM82ussxx8OHJTenNvfkBu59tkHHADvqk
# Username:admin , Password: Metricpass.24
export fqdnHost=ib2.vir-gol.ir
# BBB Exporter
curl -u admin:Metricpass.24 https://$fqdnHost/metrics/
# Node Exporter
curl -u admin:Metricpass.24 http://$fqdnHost:9100/metrics
# CAdvisor
curl -u admin:Metricpass.24 http://$fqdnHost:9338/containers/
curl -u admin:Metricpass.24 http://$fqdnHost:8080/containers/

# ---------------------------------------------------------------==========---------------------------------------------------------------
#*                                                                Upgrade                                                               *#
# ---------------------------------------------------------------==========---------------------------------------------------------------
wget -qO- https://ubuntu.bigbluebutton.org/bbb-install.sh | sudo bash -s -- -v xenial-22 -s ib1.vir-gol.ir -e admin@vir-gol.ir -w -g
export version=2.3.0-beta-2
sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Settings/$version/bigbluebutton.properties /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Settings/$version/settings.yml /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml
sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Settings/$version/bigbluebutton.nginx /etc/nginx/sites-available/bigbluebutton

# Beacuse we copy other server config file, we must set these again.
sudo bbb-conf --setsecret 1b6s1esKbXNM82ussxx8OHJTenNvfkBu59tkHHADvqk
sudo bbb-conf --setip ib1.vir-gol.ir

# Check and Apply
nginx -t && nginx -s reload
sudo bbb-conf --restart

# -------==========-------
#* Imporove Audio *#
# -------==========-------
/opt/freeswitch/etc/freeswitch/dialplan/default/bbb_echo_to_conference.xml
/opt/freeswitch/etc/freeswitch/dialplan/default/bbb_conference.xml

https://github.com/bigbluebutton/bigbluebutton/issues/7007

# -------==========-------
# BBB Livestreaming
# -------==========-------
# It have 100Sec delay
cd ~/dev
git clone https://github.com/Hamid-Najafi/BigBlueButton-liveStreaming.git 
cd ~/dev/BigBlueButton-liveStreaming/
docker-compose up -d
docker-compose down
# Join as moderator
https://ib1.vir-gol.ir/bigbluebutton/api/join?fullName=Admin&meetingID=livesteam-1&password=mp&redirect=true&checksum=4bc4b1d088f661c0d9ebe34b177e81dfe5d55388
# Join as attendee
https://ib1.vir-gol.ir/bigbluebutton/api/join?fullName=User&meetingID=livesteam-1&password=ap&redirect=true&checksum=e68c7f594999a5770108b87075398175036ee525
# RTMP
rtmp://live.vir-gol.ir/stream/bbb-live-1
rtmp://live.vir-gol.ir/stream/MEETINGID
# HLS
https://live.vir-gol.ir/hls/bbb-live-1.m3u8
# DASH
https://live.vir-gol.ir/dash/bbb-live-1.mpd

