#!/bin/bash
echo "--------------------------"
echo "Using BBB-Apply-lib Script"
echo "--------------------------"
source /etc/bigbluebutton/bbb-conf/apply-lib.sh

echo "---------------------"
echo "Applying HTML5_CONFIG"
echo "---------------------"
yq w -i $HTML5_CONFIG public.app.skipCheck true
yq w -i $HTML5_CONFIG public.app.skipCheckOnJoin true
yq w -i $HTML5_CONFIG public.app.clientTitle 'سامانه ویرگول'
yq w -i $HTML5_CONFIG public.app.appName 'سامانه ویرگول'
yq w -i $HTML5_CONFIG public.app.copyright '©2021 Virgol Inc. Powerd by BigBlueButton' 
yq w -i $HTML5_CONFIG public.app.helpLink https://panel.vir-gol.ir/video/guide-pr
yq w -i $HTML5_CONFIG public.app.remainingTimeAlertThreshold 10
yq w -i $HTML5_CONFIG public.app.defaultSettings.application.chatPushAlerts true
yq w -i $HTML5_CONFIG public.app.defaultSettings.application.userJoinPushAlerts true
yq w -i $HTML5_CONFIG public.app.defaultSettings.application.overrideLocale fa_IR
yq w -i $HTML5_CONFIG public.caption.enabled false

echo "-----------------------"
echo "Applying BBB_WEB_CONFIG"
echo "-----------------------"
sed -i 's/numConversionThreads=.*/numConversionThreads=10/g' $BBB_WEB_CONFIG
sed -i 's/defaultWelcomeMessage=.*/defaultWelcomeMessage=\\u062c\\u0647\\u062a \\u0641\\u0639\\u0627\\u0644 \\u0633\\u0627\\u0632\\u06cc \\u0645\\u06cc\\u06a9\\u0631\\u0648\\u0641\\u0646 \\u06cc\\u0627 \\u062f\\u0648\\u0631\\u0628\\u06cc\\u0646 \\u0627\\u0632 \\u0634\\u062e\\u0635 \\u0627\\u0631\\u0627\\u0626\\u0647 \\u062f\\u0647\\u0646\\u062f\\u0647 \\u06cc\\u0627 \\u062f\\u0628\\u06cc\\u0631 \\u062f\\u0631\\u062e\\u0648\\u0627\\u0633\\u062a \\u06a9\\u0646\\u06cc\\u062f \\u0628\\u0627 \\u06a9\\u0644\\u06cc\\u06a9 \\u0631\\u0648\\u06cc \\u0646\\u0627\\u0645 \\u0634\\u0645\\u0627\\u060c \\u0642\\u0641\\u0644 \\u06a9\\u0627\\u0631\\u0628\\u0631 \\u0634\\u0645\\u0627 \\u0631\\u0627 \\u063a\\u06cc\\u0631\\u0641\\u0639\\u0627\\u0644 \\u06a9\\u0646\\u062f \\u062c\\u0647\\u062a \\u062c\\u0644\\u0648\\u06af\\u06cc\\u0631\\u06cc \\u0627\\u0632 \\u062a\\u062f\\u0627\\u062e\\u0644 \\u0635\\u062f\\u0627 \\u0648 \\u0646\\u0648\\u06cc\\u0632 \\u0644\\u0637\\u0641\\u0627 \\u0627\\u0632 \\u0647\\u062f\\u0633\\u062a \\u0627\\u0633\\u062a\\u0641\\u0627\\u062f\\u0647 \\u06a9\\u0646\\u06cc\\u062f./g' $BBB_WEB_CONFIG
sed -i 's/defaultWelcomeMessageFooter=.*/defaultWelcomeMessageFooter=\\u062c\\u0647\\u062a \\u0641\\u0639\\u0627\\u0644 \\u0633\\u0627\\u0632\\u06cc \\u0645\\u06cc\\u06a9\\u0631\\u0648\\u0641\\u0646 \\u06cc\\u0627 \\u062f\\u0648\\u0631\\u0628\\u06cc\\u0646 \\u0627\\u0632 \\u062f\\u0628\\u06cc\\u0631 \\u062f\\u0631\\u062e\\u0648\\u0627\\u0633\\u062a \\u06a9\\u0646\\u06cc\\u062f \\u06a9\\u0647 \\u0628\\u0627 \\u06a9\\u0644\\u06cc\\u06a9 \\u0631\\u0648\\u06cc \\u0646\\u0627\\u0645 \\u0634\\u0645\\u0627\\u060c \\u0646\\u0642\\u0634 \\u0634\\u0645\\u0627 \\u0631\\u0627 \\u0628\\u0647 \\u0645\\u062f\\u06cc\\u0631 \\u0627\\u0631\\u062a\\u0642\\u0627 \\u062f\\u0647\\u062f \\u0648 \\u0628\\u0627 \\u0627\\u062a\\u0645\\u0627\\u0645 \\u0627\\u0631\\u0627\\u06cc\\u0647 \\u062e\\u0648\\u062f\\u060c \\u062c\\u0647\\u062a \\u0627\\u0641\\u0632\\u0627\\u06cc\\u0634 \\u06a9\\u06cc\\u0641\\u06cc\\u062a \\u0635\\u062f\\u0627 \\u062d\\u062a\\u0645\\u0627 \\u0642\\u0641\\u0644 \\u0628\\u0627\\u0632\\u06af\\u0631\\u062f\\u0627\\u0646\\u062f\\u0647 \\u0634\\u0648\\u062f. \\u0647\\u0645\\u0686\\u0646\\u06cc\\u0646 \\u0627\\u0645\\u06a9\\u0627\\u0646 \\u06af\\u0641\\u062a\\u200c\\u0648\\u200c\\u06af\\u0648\\u06cc \\u062e\\u0635\\u0648\\u0635\\u06cc \\u0628\\u06cc\\u0646 \\u062f\\u0627\\u0646\\u0634 \\u0622\\u0645\\u0648\\u0632\\u0627\\u0646 \\u063a\\u06cc\\u0631\\u0641\\u0639\\u0627\\u0644 \\u0628\\u0648\\u062f\\u0647 \\u0648 \\u062a\\u0646\\u0647\\u0627 \\u06af\\u0641\\u062a\\u200c\\u0648\\u200c\\u06af\\u0648\\u06cc \\u062e\\u0635\\u0648\\u0635\\u06cc \\u0628\\u0627 \\u062f\\u0628\\u06cc\\u0631 \\u0627\\u0645\\u06a9\\u0627\\u0646 \\u067e\\u0630\\u06cc\\u0631 \\u0627\\u0633\\u062a.  \\u062c\\u0647\\u062a \\u062c\\u0644\\u0648\\u06af\\u06cc\\u0631\\u06cc \\u0627\\u0632 \\u062a\\u062f\\u0627\\u062e\\u0644 \\u0635\\u062f\\u0627 \\u0648 \\u0646\\u0648\\u06cc\\u0632 \\u0644\\u0637\\u0641\\u0627 \\u0627\\u0632 \\u0647\\u062f\\u0633\\u062a \\u0627\\u0633\\u062a\\u0641\\u0627\\u062f\\u0647 \\u06a9\\u0646\\u06cc\\u062f./g' $BBB_WEB_CONFIG
sed -i 's/defaultMaxUsers=.*/defaultMaxUsers=150/g' $BBB_WEB_CONFIG
sed -i 's/meetingExpireIfNoUserJoinedInMinutes=.*/meetingExpireIfNoUserJoinedInMinutes=1440/g' $BBB_WEB_CONFIG
sed -i 's/meetingExpireWhenLastUserLeftInMinutes=.*/meetingExpireWhenLastUserLeftInMinutes=1440/g' $BBB_WEB_CONFIG
sed -i 's/breakoutRoomsEnabled=.*/breakoutRoomsEnabled=false/g' $BBB_WEB_CONFIG
sed -i 's/lockSettingsDisableCam=.*/lockSettingsDisableCam=true/g' $BBB_WEB_CONFIG
sed -i 's/lockSettingsDisableMic=.*/lockSettingsDisableMic=true/g' $BBB_WEB_CONFIG
sed -i 's/lockSettingsDisablePrivateChat=.*/lockSettingsDisablePrivateChat=true/g' $BBB_WEB_CONFIG
sed -i 's/lockSettingsDisableNote=.*/lockSettingsDisableNote=true/g' $BBB_WEB_CONFIG
# Set "lockSettingsLockOnJoin" to "TRUE" enable lock settings
sed -i 's/lockSettingsLockOnJoin=.*/lockSettingsLockOnJoin=false/g' $BBB_WEB_CONFIG
sed -i 's/lockSettingsLockOnJoinConfigurable=.*/lockSettingsLockOnJoinConfigurable=false/g' $BBB_WEB_CONFIG
sed -i 's/allowDuplicateExtUserid=.*/allowDuplicateExtUserid=false/g' $BBB_WEB_CONFIG

echo "-----------------------------------------"
echo "Use MP4 format for playback of recordings"
echo "-----------------------------------------"
sed -i 's/# - mp4/- mp4/g' /usr/local/bigbluebutton/core/scripts/presentation.yml
# sed -i 's/- webm/# - webm/g' /usr/local/bigbluebutton/core/scripts/presentation.yml

echo "-------------------------------------"
echo "Optimize NodeJS (If 16GB RAM or more)"
echo "-------------------------------------"
sed -i 's/--max-old-space-size=2048/--max-old-space-size=4096/g' /usr/share/meteor/bundle/systemd_start.sh
service bbb-html5 restart

echo "-------------"
echo "Cloning repos"
echo "-------------"
git clone https://github.com/Hamid-Najafi/DevOps-Notebook.git /root/DevOps-Notebook || cd /root/DevOps-Notebook && git pull
git clone https://github.com/Hamid-Najafi/FontPack.git  /usr/share/fonts/FontPack || cd /usr/share/fonts/FontPack && git pull
git clone https://github.com/Hamid-Najafi/bbb-download.git /root/bbb-download || cd /root/bbb-download && git pull

echo "-------------------------------"
echo "Installing Persian translations"
echo "-------------------------------"
cp /usr/share/meteor/bundle/programs/web.browser/app/locales/fa_IR.json{,.backup}
cp /usr/share/meteor/bundle/programs/web.browser.legacy/app/locales/fa_IR.json{,.backup}
cp /root/DevOps-Notebook/Apps/BigBlueButton/Settings/fa_IR.json /usr/share/meteor/bundle/programs/web.browser/app/locales/
cp /root/DevOps-Notebook/Apps/BigBlueButton/Settings/fa_IR.json /usr/share/meteor/bundle/programs/web.browser.legacy/app/locales/

echo "----------------------------------"
echo "build font information cache files"
echo "----------------------------------"
fc-cache -fv

echo "---------------"
echo "Setting favicon"
echo "---------------"
cp /root/DevOps-Notebook/Apps/BigBlueButton/Theme/Virgol/favicon.ico /var/www/bigbluebutton-default/favicon.ico

echo "-------------------------"
echo "Copying presentation PDFs"
echo "-------------------------"
cp /root/DevOps-Notebook/Apps/BigBlueButton/Theme/Virgol/Whiteboard-Virgol.pdf /var/www/bigbluebutton-default/default.pdf
# cp /root/DevOps-Notebook/Apps/BigBlueButton/Theme/Custom/Javaneha.pdf  /var/www/bigbluebutton-default/
find /root/DevOps-Notebook/Apps/BigBlueButton/Theme -type f -name "*.pdf" | xargs cp -t /var/www/bigbluebutton-default/

echo "--------------------------"
echo "Removing freeswitch sounds"
echo "--------------------------"
mv /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conferenceBackup

# echo "Delete raw recordings older than 14 days script"
# sudo nano /etc/cron.daily/bigbluebutton
# # uncommenting the following line
# remove_raw_of_published_recordings

echo "-------------------------------------------"
echo "Delete recordings older than 12 days script"
echo "-------------------------------------------"
cp /root/DevOps-Notebook/Apps/BigBlueButton/Settings/bbb-recording-cleanup.sh /etc/cron.daily/bbb-recording-cleanup
chmod +x /etc/cron.daily/bbb-recording-cleanup

echo "---------------------------------------"
echo "Increase number of processes for nodejs"
echo "---------------------------------------"
sed -i 's/NUMBER_OF_BACKEND_NODEJS_PROCESSES=.*/NUMBER_OF_BACKEND_NODEJS_PROCESSES=4/g' /usr/share/meteor/bundle/bbb-html5-with-roles.conf
sed -i 's/NUMBER_OF_FRONTEND_NODEJS_PROCESSES=.*/NUMBER_OF_FRONTEND_NODEJS_PROCESSES=4/g' /usr/share/meteor/bundle/bbb-html5-with-roles.conf

echo "------------------------------------"
echo "Increase number of recording workers"
echo "------------------------------------"
# Best value= CPUs / 2
mkdir -p /etc/systemd/system/bbb-rap-resque-worker.service.d
cat > /etc/systemd/system/bbb-rap-resque-worker.service.d/override.conf << EOF
[Service]
Environment=COUNT=28
EOF

echo "--------------------------------------------------"
echo "Restart BBB Recording Services"
echo "--------------------------------------------------"
# systemctl list-timers --all
systemctl daemon-reload
systemctl enable bbb-rap-starter.service
systemctl enable bbb-rap-resque-worker.service

systemctl restart bbb-rap-starter.service
systemctl restart bbb-rap-resque-worker.service

systemctl status bbb-rap-starter.service
systemctl status bbb-rap-resque-worker.service

echo "--------------------------------------------------"
echo "Set Cropnjob for recorded sessions processing task"
echo "--------------------------------------------------"
sudo timedatectl set-timezone Asia/Tehran 
(crontab -l 2>/dev/null; echo "@reboot mount -t auto $externalDisk /mnt/hdd") | crontab -
(crontab -l 2>/dev/null; echo "0 7 * * * systemctl stop bbb-rap-resque-worker") | crontab -
(crontab -l 2>/dev/null; echo "0 18 * * * systemctl start bbb-rap-starter") | crontab -
(crontab -l 2>/dev/null; echo "0 18 * * * systemctl start bbb-rap-resque-worker") | crontab -

echo "------------------"
echo "Configuring secret"
echo "------------------"
bbb-conf --setsecret 1b6s1esKbXNM82ussxx8OHJTenNvfkBu59tkHHADvqk

echo "--------------"
echo "Restarting BBB"
echo "--------------"
bbb-conf --restart

echo "----------------------"
echo "Configuring exporters"
echo "bbb-exporter"
echo "----------------------"
cp -R /root/DevOps-Notebook/Apps/BigBlueButton/Monitoring/bbb-exporter /root/bbb-exporter 
sed -i 's|API_BASE_URL=.*|API_BASE_URL=https:\/\/'$1'\/bigbluebutton\/api\/|g' /root/bbb-exporter/secrets.env
docker-compose -f /root/bbb-exporter/docker-compose.yaml up -d

echo "-------------------------"
echo "node-exporter & cadvisor"
echo "-------------------------"
cp -R /root/DevOps-Notebook/Apps/Monitoring/Slave/ /root/monitoring
docker-compose -f /root/monitoring/docker-compose.yml up -d

echo "----------------------"
echo "Applying NGINX_CONFIG"
echo "----------------------"
sed -i '$d' /etc/nginx/sites-available/bigbluebutton
cat >> /etc/nginx/sites-available/bigbluebutton << EOF
  location /metrics/ {
      auth_basic "BigBlueButton Exporter";
      auth_basic_user_file /etc/nginx/.htpasswd;
      proxy_pass http://127.0.0.1:9688/;
      include proxy_params;
  }
  location = / {
    return 301 https://panel.vir-gol.ir/;
  }
}
EOF

echo "----------------------"
echo "Configuring Nginx auth"
echo "----------------------"
echo 'admin:$apr1$k98EN1wL$.4puamdnCPS46oGRDvRKx/' | tee /etc/nginx/.htpasswd
nginx -t &&  nginx -s reload

echo "--------------------"
echo "Configuring Firewall"
echo "--------------------"
ufw allow 9100
ufw allow 9338
ufw allow 9688

echo "------------------------"
echo "Configuring bbb-download"
echo "------------------------"
# Uses webm format
chmod u+x /root/bbb-download/install.sh
/root/bbb-download/install.sh 

echo "-----------------------"
echo "Configuring greenlight"
echo "-----------------------"
rm /etc/bigbluebutton/nginx/greenlight-redirect.nginx
sed -i 's/BIGBLUEBUTTON_SECRET=.*/BIGBLUEBUTTON_SECRET=1b6s1esKbXNM82ussxx8OHJTenNvfkBu59tkHHADvqk/g' /root/greenlight/.env
docker run --rm --env-file /root/greenlight/.env bigbluebutton/greenlight:v2 bundle exec rake conf:check
docker-compose -f /root/greenlight/docker-compose.yml up -d
docker exec greenlight-v2 bundle exec rake user:create["Admin","admin@vir-gol.ir","BBBpass.24","admin"]

echo "---------------"
echo "Disabling Proxy"
echo "---------------"
sed -e '/http_proxy/ s/^#*/#/' -i  /etc/environment && sed -e '/https_proxy/ s/^#*/#/' -i  /etc/environment

while true; do
    read -p "System Reboot is recommended.[Yy/Nn]" yn
    case $yn in
        [Yy]* ) reboot;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo "Done!"
