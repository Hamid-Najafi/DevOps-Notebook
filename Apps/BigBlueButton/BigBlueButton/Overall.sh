# -------==========-------
# **** Quick Install ****
# -------==========-------
su root
export FQDN=ib2.vir-gol.ir

bash QuickInstall.sh $FQDN
# -------==========-------
# Pre-install
# -------==========-------
# Set host to use proxy
# ITS NECESSARY FOR BBB 2.3
echo -e "http_proxy=http://admin:Squidpass.24@su.legace.ir:3128/\nhttps_proxy=http://admin:Squidpass.24@su.legace.ir:3128/" | sudo tee -a /etc/environment
sudo apt install resolvconf
echo -e "nameserver 185.51.200.2\nnameserver 178.22.122.100" | sudo tee -a /etc/resolvconf/resolv.conf.d/head
sudo service resolvconf restart
wget https://charts.gitlab.io 

# Set Hostname
sudo hostnamectl set-hostname ib2
sudo nano /etc/hosts  
127.0.1.1 ib2

# Ubuntu Automatic Update
sudo nano /etc/update-manager/release-upgrades

sudo reboot
# -------==========-------
# BigBlueButton
# -------==========-------
# export fqdnHost=ib2.vir-gol.ir
# export version=2.3.0-beta-3
echo -e "fqdnHost=ib2.vir-gol.ir\nversion=2.3.0-beta-3" | sudo tee -a /etc/environment
source /etc/environment

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
# Set Images
# -------==========-------
git clone https://github.com/Hamid-Najafi/DevOps-Notebook.git
# FAVICON
sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Theme/Virgol/favicon.ico /var/www/bigbluebutton-default/favicon.ico
sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Theme/Sampad/favicon.ico /var/www/bigbluebutton-default/favicon.ico
sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Theme/Dei/favicon.ico /var/www/bigbluebutton-default/favicon.ico
# PDF
sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Theme/Virgol/Whiteboard.pdf /var/www/bigbluebutton-default/default.pdf
sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Theme/Virgol/Whiteboard.pdf /var/www/bigbluebutton-default/Whiteboard-Virgol.pdf
sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Theme/Sampad/Whiteboard.pdf /var/www/bigbluebutton-default/Whiteboard-Sampad.pdf
sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Theme/Dei/Whiteboard.pdf /var/www/bigbluebutton-default/Whiteboard-DEI.pdf
sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Theme/Custom/Javaneha.pdf /var/www/bigbluebutton-default/Whiteboard-Javaneha.pdf
# -------==========-------
# BBB - Configs     
# -------==========-------
# sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Settings/$version/Orig/bigbluebutton.properties.orig /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
# sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Settings/$version/Orig/settings.yml.orig /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml
# sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Settings/$version/Orig/bigbluebutton.nginx /etc/nginx/sites-available/bigbluebutton

sudo mv /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conferenceBackup
sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Settings/$version/bigbluebutton.properties /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Settings/$version/settings.yml /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml
sudo bbb-conf --setsecret 1b6s1esKbXNM82ussxx8OHJTenNvfkBu59tkHHADvqk
sudo bbb-conf --setip $fqdnHost
sudo bbb-conf --clean
sudo bbb-conf --check

1.Delete raw data from published recordings
sudo nano /etc/cron.daily/bigbluebutton
# uncommenting the following line
remove_raw_of_published_recordings

# -------==========-------
# 2.Delete recordings older than N days
# -------==========-------
sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Settings/bbb-recording-cleanup.sh /etc/cron.daily/bbb-recording-cleanup
chmod +x /etc/cron.daily/bbb-recording-cleanup
sudo nano /etc/cron.daily/bbb-recording-cleanup
# -------==========-------
# 3.Move recordings to a different partition
# -------==========-------
sudo bbb-conf --stop

sudo mv /opt/freeswitch/recordings /mnt
sudo ln -s /mnt/recordings /opt/freeswitch/recordings

sudo mv /usr/share/red5/webapps/video/streams /mnt
sudo ln -s /mnt/streams /usr/share/red5/webapps/video/streams

sudo /var/bigbluebutton /mnt
sudo ln -s /mnt/bigbluebutton /var/bigbluebutton

sudo bbb-conf --start
# -------==========-------
# 4.Increase number of processes for nodejs
# -------==========-------
sudo nano /usr/share/meteor/bundle/bbb-html5-with-roles.conf
# -------==========-------
# 5.Increase number of recording workers
# -------==========-------
# systemd main service
# /usr/lib/systemd/system/bbb-rap-resque-worker.service
# systemd override file
mkdir -p /etc/systemd/system/bbb-rap-resque-worker.service.d
cat > /etc/systemd/system/bbb-rap-resque-worker.service.d/override.conf << EOF
[Service]
Environment=COUNT=20
EOF
# nano /etc/systemd/system/bbb-rap-resque-worker.service.d/override.conf
systemctl daemon-reload
systemctl restart bbb-rap-resque-worker.service
systemctl status bbb-rap-resque-worker.service
# -------==========-------
# 6. Change recorded sessions processing time
# -------==========-------
# systemd main service
# nano /etc/systemd/system/bbb-record-core.timer
# systemd override file
mkdir -p /etc/systemd/system/bbb-record-core.timer.d
cat > /etc/systemd/system/bbb-record-core.timer.d/override.conf << EOF
[Timer]
OnActiveSec=
OnUnitInactiveSec=
OnCalendar=19,20,21,22,23,00,01:*:00
Persistent=false
EOF
systemctl daemon-reload
# rm -rf  /etc/systemd/system/bbb-record-core.timer.d
sudo bbb-conf --restart
# -------==========-------
# Install Fonts
# -------==========-------
sudo git clone https://github.com/Hamid-Najafi/FontPack.git  /usr/share/fonts/FontPack
sudo fc-cache -fv
# -------==========-------
# Greenlight
# -------==========-------
sudo rm /etc/bigbluebutton/nginx/greenlight-redirect.nginx
cd ~/greenlight
sudo nano .env
BIGBLUEBUTTON_SECRET=1b6s1esKbXNM82ussxx8OHJTenNvfkBu59tkHHADvqk
sudo docker run --rm --env-file .env bigbluebutton/greenlight:v2 bundle exec rake conf:check
sudo docker-compose up -d
sudo docker exec greenlight-v2 bundle exec rake user:create["Admin","admin@vir-gol.ir","BBBpass.24","admin"]
# -------==========-------
# Monitoring
# -------==========-------
# BBB Exporter
cp -R ~/DevOps-Notebook/Apps/BigBlueButton/Monitoring/bbb-exporter ~/bbb-exporter 
cd ~/bbb-exporter
sudo nano secrets.env
# * Set FQDDN Address *#
sudo docker-compose up -d

# Node Exporter
cp -R ~/DevOps-Notebook/Apps/Monitoring/Slave/ ~/monitoring
cd ~/monitoring
sudo docker-compose up -d

# Nginx auth for exporters
echo 'admin:$apr1$k98EN1wL$.4puamdnCPS46oGRDvRKx/' | sudo tee /etc/nginx/.htpasswd
sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Settings/$version/bigbluebutton.nginx /etc/nginx/sites-available/bigbluebutton
nano /etc/nginx/sites-available/bigbluebutton
# * Set FQDDN Address *#
sudo nginx -t && sudo nginx -s reload

sudo ufw allow 9100
sudo ufw allow 9338
sudo ufw allow 9688
# -------==========-------
# Prometheus Montoring
# -------==========-------
# run in monitoring server
cd docker/monitoringLite/
nano prometheus/prometheus.yml
# add server address to 'nodeexporter' , 'cadvisor', and 'bbb' Jobs
docker-compose up -d --force-recreate --no-deps prometheus
# -------==========-------
# Downloadable Recording
# -------==========-------
# git clone https://github.com/vova-zush/bbb-download.git ~/bbb-download
git clone https://github.com/Hamid-Najafi/bbb-download.git ~/bbb-download
cd ~/bbb-download
chmod u+x install.sh 
sudo ./install.sh
bbb-conf --restart
# To convert all of your current recordings to MP4 format use command:
sudo bbb-record --rebuildall
sudo bbb-record --list
sudo bbb-record --rebuild 013c5db3388968aca08dd0350913345545303d8e-1617597209571
sudo bbb-record --rebuild 64c863ab0739360c689fc6d45bad5f97fa9c5c8f-1618186276307
https://ib2.vir-gol.ir/playback/presentation/2.3/013c5db3388968aca08dd0350913345545303d8e-1617597209571
https://ib2.vir-gol.ir/download/presentation/{InternalmeetingID}/{InternalmeetingID}.mp4
https://ib2.vir-gol.ir/download/presentation/013c5db3388968aca08dd0350913345545303d8e-1617597209571/013c5db3388968aca08dd0350913345545303d8e-1617597209571.mp4
https://ib2.vir-gol.ir/download/presentation/6b35a9c681e8c6d7e64d10bd2662c48c6d5c2f88-1618119138489/6b35a9c681e8c6d7e64d10bd2662c48c6d5c2f88-1618119138489.mp4
https://ib2.vir-gol.ir/download/presentation/134c0b3b267df918319e6ec823c789cf712888be-1617773562988/134c0b3b267df918319e6ec823c789cf712888be-1617773562988.mp4
https://ib2.vir-gol.ir/playback/presentation/2.3/9c9e16629f9176df30ec52a7d57d46d4c6213274-1618199732033

# Run standalone
/usr/bin/python /usr/local/bigbluebutton/core/scripts/post_publish/download.py 64c863ab0739360c689fc6d45bad5f97fa9c5c8f-1618186276307
cd /usr/local/bigbluebutton/core/scripts/post_publish && ruby download_control.rb -m  64c863ab0739360c689fc6d45bad5f97fa9c5c8f-1618186276307
# Logs
ls -la /var/log/bigbluebutton/download
# Videos
# /var/bigbluebutton/published/presentation &  /var/www/bigbluebutton-default/download/presentation
ls -la /var/bigbluebutton/published/presentation
ls -la /var/bigbluebutton/published/presentation/64c863ab0739360c689fc6d45bad5f97fa9c5c8f-1618186276307/
# -------==========-------
# Test
# -------==========-------
# Postman or Firefox:
# BBB
curl https://ib2.vir-gol.ir/bigbluebutton/api/
https://mconf.github.io/api-mate/#server=https://ib2.vir-gol.ir/bigbluebutton/&sharedSecret=1b6s1esKbXNM82ussxx8OHJTenNvfkBu59tkHHADvqk
# Username:admin , Password: Metricpass.24
export fqdnHost=ib2.vir-gol.ir
# BBB Exporter
curl -u admin:Metricpass.24 https://$fqdnHost/metrics/
# Node Exporter
curl -u admin:Metricpass.24 http://$fqdnHost:9100/metrics
# CAdvisor
curl -u admin:Metricpass.24 http://$fqdnHost:9338/containers/
# curl -u admin:Metricpass.24 http://$fqdnHost:8080/containers/
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
# Change Locales 
# -------==========-------
# List
ls /usr/share/meteor/bundle/programs/server/assets/app/locales/
# Set to Arabic
sudo nano /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml
        fallbackLocale: en
        overrideLocale: ar
sudo nano /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
# -------==========-------
# Uninstall
# -------==========-------
# ******** NOTEICE ********
# * Backup all recorded meetings first!
unlink /var/bigbluebutton
# -------==========-------

sudo apt-get purge nodejs mongodb-org  bigbluebutton bbb-* 
# OR
sudo apt-get purge bbb-apps bbb-apps-akka bbb-apps-screenshare bbb-apps-sip bbb-apps-video bbb-apps-video-broadcast bbb-client bbb-etherpad \
bbb-freeswitch-core bbb-freeswitch-sounds bbb-fsesl-akka bbb-mkclean bbb-playback-presentation bbb-record-core bbb-red5 bbb-transcode-akka bbb-web

sudo apt-get purge nodejs mongodb-org bbb-apps-akka bbb-freeswitch-core bbb-html5 bbb-playback bbb-web bbb-config bbb-freeswitch-sounds \
bbb-playback-presentation bbb-webrtc-sfu bbb-etherpad  bbb-fsesl-akka bbb-mkclean bbb-record-core bbb-libreoffice-docker

apt --fix-broken install

sudo apt-get purge bbb-record-core 

#sudo apt-get purge apt-transport-https haveged build-essential yq
sudo apt autoremove
sudo ufw disable
# -------==========-------
# Upgrade
# -------==========-------
export fqdnHost=ib2.vir-gol.ir
export version=2.3.0-beta-3

wget -qO- https://ubuntu.bigbluebutton.org/bbb-install.sh | sudo bash -s -- -v xenial-22 -s ib1.vir-gol.ir -e admin@vir-gol.ir -w -g
wget -qO- https://ubuntu.bigbluebutton.org/bbb-install.sh | sudo bash -s -- -v bionic-230 -s $fqdnHost -e admin@vir-gol.ir -g -w
sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Settings/$version/bigbluebutton.properties /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Settings/$version/settings.yml /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml
sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Settings/$version/bigbluebutton.nginx /etc/nginx/sites-available/bigbluebutton
sudo bbb-conf --setsecret 1b6s1esKbXNM82ussxx8OHJTenNvfkBu59tkHHADvqk
sudo bbb-conf --setip $fqdnHost
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

# -------==========-------
# BBB Server
# -------==========-------
# Minimum Req
Memory: 4GB
OS: Ubuntu 16 or 18 (64bit)
# Utilization
400 Person: 
12GB Ram
12 Core @ 2.10GHz
200 Person:
8GB Ram
8 Core @ 2.10GHz