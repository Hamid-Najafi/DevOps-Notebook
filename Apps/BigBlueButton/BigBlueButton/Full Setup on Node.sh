# Docs:
https://docs.bigbluebutton.org/2.2/customize.html

# -------==========-------
# Pre-install
# -------==========-------
# Set host to use proxy
# echo -e "http_proxy=http://admin:Squidpass.24@su.legace.ir:3128/\nhttps_proxy=http://admin:Squidpass.24@su.legace.ir:3128/\nftp_proxy=http://admin:Squidpass.24@su.legace.ir:3128/" | sudo tee -a /etc/environment
# source /etc/environment

# Set Hostname
sudo hostnamectl set-hostname big-1
BBB-1

# sudo nano /etc/cloud/templates/hosts.debian.tmpl
sudo nano /etc/hosts  
127.0.0.1 big-1
127.0.0.1 b1.legace.ir

# Ubuntu Automatic Update
sudo nano /etc/update-manager/release-upgrades

# DNS
sudo apt install resolvconf
sudo nano /etc/resolvconf/resolv.conf.d/head
# Shecan
nameserver 185.51.200.2
nameserver 178.22.122.100
# Begzar
#nameserver 185.55.226.2
#nameserver 185.55.225.25
sudo service resolvconf restart

sudo reboot
# -------==========-------
# install
# -------==========-------
sudo apt install base-files
#*    Set FQDN Correctly     *#
wget -qO- https://ubuntu.bigbluebutton.org/bbb-install.sh | sudo bash -s -- -v xenial-22 -s ib1.legace.ir -e admin@legace.ir -w -g
wget -qO- https://ubuntu.bigbluebutton.org/bbb-install.sh | sudo bash -s -- -v bionic-230-dev -s bbb.goldenstarc.ir -e admin@legace.ir -w -g -a
# -------==========-------
# Set Images
# -------==========-------
# Virgol
git clone https://github.com/Hamid-Najafi/DevOps-Notebook.git
sudo cp /var/www/bigbluebutton-default/favicon.ico{,.backup}
sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Theme/favicon.ico /var/www/bigbluebutton-default/favicon.ico
sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Theme/Slides/virgol-min.pdf /var/www/bigbluebutton-default/
sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Theme/Slides/Whiteboard-Virgol.pdf /var/www/bigbluebutton-default/

# -------==========-------
#*    BBB - Configs     *#
# -------==========-------
sudo mv /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conferenceBackup
sudo cp /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties{,.backup}
sudo cp /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml{,.backup}
# This is for Version 2.2.29, if BBB is updated, first update setting files
sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Settings/2.2.29/bigbluebutton.properties /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Settings/2.2.29/settings.yml /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml
sudo bbb-conf --setsecret 1b6s1esKbXNM82ussxx8OHJTenNvfkBu59tkHHADvqk
#*    Set FQDN Correctly     *#
sudo bbb-conf --setip ib1.legace.ir

# Locales #
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
# -------==========-------
# 1. Hostname & Secrets
# -------==========-------
# Dont run setip, use install-script to change FQDN instead.
# sudo bbb-conf --setip b1.legace.ir
# sudo bbb-conf --setip bbb.goldenstarc.ir
# sudo bbb-conf --setsecret 1b6s1esKbXNM82ussxx8OHJTenNvfkBu59tkHHADvqk
# sudo bbb-conf --restart
# -------==========-------
# 2. Remove Demo API
# -------==========-------
sudo apt-get purge bbb-demo
# Secret Location
# Version 2.2
sudo nano /var/lib/tomcat7/webapps/demo/bbb_api_conf.jsp
# Version 2.3
sudo nano /var/lib/tomcat8/webapps/demo/bbb_api_conf.jsp
# -------==========-------
# 3. Setup Greenligh (if needed)
# -------==========-------
sudo rm /etc/bigbluebutton/nginx/greenlight-redirect.nginx
cd ~/greenlight
sudo nano .env
BIGBLUEBUTTON_SECRET=1b6s1esKbXNM82ussxx8OHJTenNvfkBu59tkHHADvqk
sudo docker run --rm --env-file .env bigbluebutton/greenlight:v2 bundle exec rake conf:check
sudo docker-compose up -d
sudo docker exec greenlight-v2 bundle exec rake user:create["Admin","admin@legace.ir","BBBpass.24","admin"]
# -------==========-------
# 3. Downloadable Recording
# -------==========-------
git clone https://github.com/vova-zush/bbb-download.git
cd bbb-download
chmod u+x install.sh 
sudo ./install.sh
# To convert all of your current recordings to MP4 format use command:
sudo bbb-record --rebuildall
sudo bbb-record --list
https://b1.legace.ir/download/presentation/{InternalmeetingID}/{InternalmeetingID}.mp4
# -------==========-------
# 3. Setup Monitoring
# -------==========-------
# BBB Exporter
cd ~/DevOps-Notebook/Apps/BigBlueButton/Monitoring/bbb-exporter/
# If needed edit secret file
# bbb-conf --secret
sudo nano secrets.env
#*    Set FQDN Correctly     *#
API_BASE_URL=https://ib1.legace.ir/bigbluebutton/api/
API_SECRET=1b6s1esKbXNM82ussxx8OHJTenNvfkBu59tkHHADvqk
# Fix IP Address
sudo docker-compose up -d
sudo apt-get install -y apache2-utils
# Username:metrics , Password: monitor@bbb
sudo htpasswd -c /etc/nginx/.htpasswd metrics
# Add bbb exporter to Nginx (in the last line just before '}' )
sudo nano /etc/nginx/sites-available/bigbluebutton 
  location /metrics/ {
      auth_basic "BigBlueButton Exporter";
      auth_basic_user_file /etc/nginx/.htpasswd;
      proxy_pass http://127.0.0.1:9688/;
      include proxy_params;
  }
  location = / {
    return 301 https://lms.legace.ir/;
  }

# Node Exporter
cd ~/DevOps-Notebook/Apps/Monitoring/Slave/
sudo docker-compose up -d
nginx -t && nginx -s reload
# Check:
https://ib1.legace.ir/metrics/
http://b1.legace.ir:9100
http://b1.legace.ir:8080 || http://b1.legace.ir:9338

https://mconf.github.io/api-mate/#server=https://b1.legace.ir/bigbluebutton/&sharedSecret=1b6s1esKbXNM82ussxx8OHJTenNvfkBu59tkHHADvqk

# -------==========-------
#* Prometheus Montoring *#
# -------==========-------
# Serverius
cd  /home/ubuntu/docker/monitoring
nano prometheus/prometheus.yml
# add server address to 'nodeexporter' and 'bbb' Jobs
docker-compose down && docker-compose up -d

# -------==========-------
# Cron Job
# -------==========-------
sudo nano /etc/cron.daily/bigbluebutton

# ---------------------------------------------------------------==========---------------------------------------------------------------
#*                                                                Upgrade                                                               *#
# ---------------------------------------------------------------==========---------------------------------------------------------------
wget -qO- https://ubuntu.bigbluebutton.org/bbb-install.sh | sudo bash -s -- -v xenial-22 -s b1.legace.ir -e admin@legace.ir -w -g
sudo cp /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties{,.backup}
sudo cp /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml{,.backup}
sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Settings/2.2.*/bigbluebutton.properties /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
sudo cp ~/DevOps-Notebook/Apps/BigBlueButton/Settings/2.2.*/settings.yml /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml
# Beacuse we copy other server config file, we must set these again.
sudo bbb-conf --setsecret 1b6s1esKbXNM82ussxx8OHJTenNvfkBu59tkHHADvqk
sudo bbb-conf --setip b1.legace.ir

sudo nano /etc/nginx/sites-available/bigbluebutton 
  location /metrics/ {
      auth_basic "BigBlueButton Exporter";
      auth_basic_user_file /etc/nginx/.htpasswd;
      proxy_pass http://127.0.0.1:9688/;
      include proxy_params;
  }
  location = / {
    return 301 https://lms.legace.ir/;
  }
# Check and Apply
nginx -t && nginx -s reload
sudo bbb-conf --restart

# -------==========-------
#* Imporove Audio *#
# -------==========-------
/opt/freeswitch/etc/freeswitch/dialplan/default/bbb_echo_to_conference.xml
/opt/freeswitch/etc/freeswitch/dialplan/default/bbb_conference.xml

https://github.com/bigbluebutton/bigbluebutton/issues/7007