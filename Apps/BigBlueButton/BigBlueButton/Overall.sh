# -------==========-------
# **** Pre Install ****
su root
wget https://raw.githubusercontent.com/Hamid-Najafi/DevOps-Notebook/master/Apps/BigBlueButton/BigBlueButton/PreInstall.sh
chmod +x PreInstall.sh
# -------==========-------
# "Configure FQDN"
echo -e "FQDN=b2.vir-gol.ir" | sudo tee -a /etc/environment
source /etc/environment
# -------==========-------
# BBB 2.3 + Coturn - Ubuntu 18.04
wget -qO- https://ubuntu.bigbluebutton.org/bbb-install.sh | bash -s -- -v bionic-230 -s $FQDN -e admin@vir-gol.ir -g -w -c turn.vir-gol.ir:1b6s1esK

# BBB 2.3 - Ubuntu 18.04
# wget -qO- http://ubuntu.bigbluebutton.org/bbb-install.sh | bash -s -- -v bionic-23 -s $FQDN -e admin@vir-gol.ir -g -w
# -------==========-------
# **** Post Install ****
wget https://raw.githubusercontent.com/Hamid-Najafi/DevOps-Notebook/master/Apps/BigBlueButton/BigBlueButton/PostInstall.sh
chmod +x PostInstall.sh
sudo ./PostInstall.sh $FQDN
# **** Config Recording ****
# -------==========-------
# -------==========-------
# **** Post Upgrade ****
# -------==========-------
# -------==========-------
su root
wget https://raw.githubusercontent.com/Hamid-Najafi/DevOps-Notebook/master/Apps/BigBlueButton/BigBlueButton/PostUpgrade.sh
chmod +x PostUpgrade.sh
./PostUpgrade.sh $FQDN
# -------==========-------
# Coturn Server - Ubuntu 20.04
# DISABLE PROXY FOR certificate REQUEST
su root
wget https://raw.githubusercontent.com/Hamid-Najafi/DevOps-Notebook/master/Apps/BigBlueButton/BigBlueButton/PreInstall.sh
chmod +x PreInstall.sh
wget -qO- https://ubuntu.bigbluebutton.org/bbb-install.sh | bash -s -- -c turn.vir-gol.ir:1b6s1esK -e admin@vir-gol.ir
# Verify Turn server is accessible
sudo apt install stun-client
stun turn.vir-gol.ir
# -------==========-------
# BBB 2.2 - Ubuntu 16.04
# wget -qO- https://ubuntu.bigbluebutton.org/bbb-install.sh | sudo bash -s -- -v xenial-22 -s $FQDN -e admin@vir-gol.ir -g -w

# BBB 2.2 specific version + Coturn - Ubuntu 16.04
# wget -qO- https://ubuntu.bigbluebutton.org/bbb-install.sh | sudo bash -s -- -v xenial-220-2.2.29 -s $FQDN -e admin@vir-gol.ir -g -w -c turn.vir-gol.ir:1b6s1esK
# -------==========-------
# Move recordings to a different partition
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
# To convert all of your current recordings to MP4 format use command:
sudo bbb-record --rebuildall
sudo bbb-record --list
sudo bbb-record --rebuild 9fb761e020658b9cef1d263b6cc0f7a2f86a145d-1632889821115
https://b2.vir-gol.ir/download/presentation/{InternalmeetingID}/{InternalmeetingID}.mp4
https://b3.vir-gol.ir/download/presentation/9fb761e020658b9cef1d263b6cc0f7a2f86a145d-1632889821115/9fb761e020658b9cef1d263b6cc0f7a2f86a145d-1632889821115.mp4
https://b2.vir-gol.ir/playback/presentation/2.3/9c9e16629f9176df30ec52a7d57d46d4c6213274-1618199732033
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
# Exporters
# -------==========-------
# Postman or Firefox:
# BBB
curl https://b1.vir-gol.ir/bigbluebutton/api/
https://mconf.github.io/api-mate/#server=https://b3.vir-gol.ir/bigbluebutton/&sharedSecret=1b6s1esKbXNM82ussxx8OHJTenNvfkBu59tkHHADvqk
# Username:admin , Password: Metricpass.24
export FQDN=b3.vir-gol.ir
# BBB Exporter
curl -u admin:Metricpass.24 https://$FQDN/metrics/
# Node Exporter
curl -u admin:Metricpass.24 http://$FQDN:9100/metrics
# CAdvisor
curl -u admin:Metricpass.24 http://$FQDN:9338/containers/
# curl -u admin:Metricpass.24 http://$fqdnHost:8080/containers/
# -------==========-------
# Demo API
# -------==========-------
sudo apt-get install bbb-demo
sudo apt-get purge bbb-demo
# Secret Location
# Version 2.2
sudo nano /var/lib/tomcat7/webapps/demo/bbb_api_conf.jsp
# Version 2.3
sudo nano /var/lib/tomcat8/webapps/demo/bbb_api_conf.jsp
# -------==========-------
# Uninstall
# -------==========-------
# ******** NOTEICE ********
# * Backup all recorded meetings first!
unlink /var/bigbluebutton
# -------==========-------
# Remove BBB Packages - Version 2.3
sudo apt-get purge -y bbb-apps-akka bbb-etherpad bbb-freeswitch-sounds bbb-html5 bbb-mkclean bbb-playback-presentation bbb-web \
bbb-config bbb-freeswitch-core bbb-fsesl-akka bbb-libreoffice-docker bbb-playback bbb-record-core bbb-webrtc-sfu

sudo apt-get purge -y nodejs mongodb-org apt-transport-https haveged build-essential yq
# clean out the local repository
sudo apt-get clean
# remove all the unnecessary packages that are no longer needed
sudo apt autoremove

sudo ufw disable

sudo reboot
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