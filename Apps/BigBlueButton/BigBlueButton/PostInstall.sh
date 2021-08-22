#!/bin/bash

# if [ $EUID != 0 ]; then err "You must run this command as root."; fi

# # echo $1 | cut -d'.' -f 1 | xargs -I{} hostnamectl set-hostname {}

# apt-get update
# LC_CTYPE=C.UTF-8 apt-get install -yq apt-transport-https ca-certificates curl gnupg-agent software-properties-common openssl resolvconf
# # echo "Configuring proxy"
# # export http_proxy=http://admin:Squidpass.24@su.legace.ir:3128/
# # export https_proxy=http://admin:Squidpass.24@su.legace.ir:3128/
# echo -e "nameserver 185.51.200.2\nnameserver 178.22.122.100" | tee -a /etc/resolvconf/resolv.conf.d/head
# service resolvconf restart

# echo "Disable Ubuntu auto update"
# sed -i 's/Prompt=.*/Prompt=never/g' /etc/update-manager/release-upgrades

# echo "Installing Docker"
# if ! apt-key list | grep -q Docker; then
#   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
# fi

# if ! dpkg -l | grep -q docker-ce; then
#   add-apt-repository \
#     "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
#     $(lsb_release -cs) \
#     stable"

#   apt-get update
#   LC_CTYPE=C.UTF-8 apt-get install -yq docker-ce docker-ce-cli containerd.io
# fi
# if ! which docker; then err "Docker did not install"; fi

# # Install Docker Compose
# if dpkg -l | grep -q docker-compose; then
#   apt-get purge -y docker-compose
# fi
# if ! which docker; then err "Docker did not install"; fi
# docker login -u goldenstarc -p hgoldenstarcn

echo "Using BBB-Apply-lib Script"
source /etc/bigbluebutton/bbb-conf/apply-lib.sh

echo "Applying HTML5_CONFIG"
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

echo "Applying BBB_WEB_CONFIG"
sed -i 's/numConversionThreads=.*/numConversionThreads=10/g' $BBB_WEB_CONFIG
sed -i 's/defaultWelcomeMessage=.*/defaultWelcomeMessage=\\u062c\\u0647\\u062a \\u0641\\u0639\\u0627\\u0644 \\u0633\\u0627\\u0632\\u06cc \\u0645\\u06cc\\u06a9\\u0631\\u0648\\u0641\\u0646 \\u06cc\\u0627 \\u062f\\u0648\\u0631\\u0628\\u06cc\\u0646 \\u0627\\u0632 \\u0634\\u062e\\u0635 \\u0627\\u0631\\u0627\\u0626\\u0647 \\u062f\\u0647\\u0646\\u062f\\u0647 \\u06cc\\u0627 \\u062f\\u0628\\u06cc\\u0631 \\u062f\\u0631\\u062e\\u0648\\u0627\\u0633\\u062a \\u06a9\\u0646\\u06cc\\u062f \\u0628\\u0627 \\u06a9\\u0644\\u06cc\\u06a9 \\u0631\\u0648\\u06cc \\u0646\\u0627\\u0645 \\u0634\\u0645\\u0627\\u060c \\u0642\\u0641\\u0644 \\u06a9\\u0627\\u0631\\u0628\\u0631 \\u0634\\u0645\\u0627 \\u0631\\u0627 \\u063a\\u06cc\\u0631\\u0641\\u0639\\u0627\\u0644 \\u06a9\\u0646\\u062f \\u062c\\u0647\\u062a \\u062c\\u0644\\u0648\\u06af\\u06cc\\u0631\\u06cc \\u0627\\u0632 \\u062a\\u062f\\u0627\\u062e\\u0644 \\u0635\\u062f\\u0627 \\u0648 \\u0646\\u0648\\u06cc\\u0632 \\u0644\\u0637\\u0641\\u0627 \\u0627\\u0632 \\u0647\\u062f\\u0633\\u062a \\u0627\\u0633\\u062a\\u0641\\u0627\\u062f\\u0647 \\u06a9\\u0646\\u06cc\\u062f./g' $BBB_WEB_CONFIG
sed -i 's/defaultWelcomeMessageFooter=.*/defaultWelcomeMessageFooter=\\u062c\\u0647\\u062a \\u0641\\u0639\\u0627\\u0644 \\u0633\\u0627\\u0632\\u06cc \\u0645\\u06cc\\u06a9\\u0631\\u0648\\u0641\\u0646 \\u06cc\\u0627 \\u062f\\u0648\\u0631\\u0628\\u06cc\\u0646 \\u0627\\u0632 \\u0634\\u062e\\u0635 \\u0627\\u0631\\u0627\\u0626\\u0647 \\u062f\\u0647\\u0646\\u062f\\u0647 \\u06cc\\u0627 \\u062f\\u0628\\u06cc\\u0631 \\u062f\\u0631\\u062e\\u0648\\u0627\\u0633\\u062a \\u06a9\\u0646\\u06cc\\u062f \\u0628\\u0627 \\u06a9\\u0644\\u06cc\\u06a9 \\u0631\\u0648\\u06cc \\u0646\\u0627\\u0645 \\u0634\\u0645\\u0627\\u060c \\u0642\\u0641\\u0644 \\u06a9\\u0627\\u0631\\u0628\\u0631 \\u0634\\u0645\\u0627 \\u0631\\u0627 \\u063a\\u06cc\\u0631\\u0641\\u0639\\u0627\\u0644 \\u06a9\\u0631\\u062f\\u0647 \\u0648 \\u0628\\u0627 \\u0627\\u062a\\u0645\\u0627\\u0645 \\u0646\\u06cc\\u0627\\u0632 \\u062c\\u0647\\u062a \\u062c\\u0644\\u0648\\u06af\\u06cc\\u0631\\u06cc \\u0627\\u0632 \\u0642\\u0637\\u0639\\u06cc \\u0635\\u062f\\u0627 \\u062d\\u062a\\u0645\\u0627 \\u0642\\u0641\\u0644 \\u0628\\u0627\\u0632\\u06af\\u0631\\u062f\\u0627\\u0646\\u062f\\u0647 \\u0634\\u0648\\u062f. \\u000a\\u000d \\u0647\\u0645\\u0686\\u0646\\u06cc\\u0646 \\u0627\\u0645\\u06a9\\u0627\\u0646 \\u06af\\u0641\\u062a\\u200c\\u0648\\u200c\\u06af\\u0648\\u06cc \\u062e\\u0635\\u0648\\u0635\\u06cc \\u063a\\u06cc\\u0631\\u0641\\u0639\\u0627\\u0644 \\u0628\\u0648\\u062f\\u0647 \\u0648 \\u062a\\u0646\\u0647\\u0627 \\u06af\\u0641\\u062a\\u200c\\u0648\\u200c\\u06af\\u0648\\u06cc \\u0639\\u0645\\u0648\\u0645\\u06cc \\u062f\\u0631 \\u062f\\u0633\\u062a\\u0631\\u0633 \\u0627\\u0633\\u062a. \\u000a\\u000d \\u062c\\u0647\\u062a \\u062c\\u0644\\u0648\\u06af\\u06cc\\u0631\\u06cc \\u0627\\u0632 \\u062a\\u062f\\u0627\\u062e\\u0644 \\u0635\\u062f\\u0627 \\u0648 \\u0646\\u0648\\u06cc\\u0632 \\u0644\\u0637\\u0641\\u0627 \\u0627\\u0632 \\u0647\\u062f\\u0633\\u062a \\u0627\\u0633\\u062a\\u0641\\u0627\\u062f\\u0647 \\u06a9\\u0646\\u06cc\\u062f./g' $BBB_WEB_CONFIG
sed -i 's/defaultMaxUsers=.*/defaultMaxUsers=150/g' $BBB_WEB_CONFIG
sed -i 's/meetingExpireIfNoUserJoinedInMinutes=.*/meetingExpireIfNoUserJoinedInMinutes=1440/g' $BBB_WEB_CONFIG
sed -i 's/meetingExpireWhenLastUserLeftInMinutes=.*/meetingExpireWhenLastUserLeftInMinutes=1440/g' $BBB_WEB_CONFIG
sed -i 's/breakoutRoomsEnabled=.*/breakoutRoomsEnabled=true/g' $BBB_WEB_CONFIG
sed -i 's/lockSettingsDisablePrivateChat=.*/lockSettingsDisablePrivateChat=true/g' $BBB_WEB_CONFIG
sed -i 's/lockSettingsDisableNote=.*/lockSettingsDisableNote=true/g' $BBB_WEB_CONFIG
sed -i 's/lockSettingsLockOnJoin=.*/lockSettingsLockOnJoin=false/g' $BBB_WEB_CONFIG
sed -i 's/lockSettingsLockOnJoinConfigurable=.*/lockSettingsLockOnJoinConfigurable=true/g' $BBB_WEB_CONFIG
sed -i 's/allowDuplicateExtUserid=.*/allowDuplicateExtUserid=false/g' $BBB_WEB_CONFIG

echo "Installing Persian translations"
cp /usr/share/meteor/bundle/programs/web.browser/app/locales/fa_IR.json{,.backup}
cp /usr/share/meteor/bundle/programs/web.browser.legacy/app/locales/fa_IR.json{,.backup}
cp /root/DevOps-Notebook/Apps/BigBlueButton/Settings/fa_IR.json /usr/share/meteor/bundle/programs/web.browser/app/locales/
cp /root/DevOps-Notebook/Apps/BigBlueButton/Settings/fa_IR.json /usr/share/meteor/bundle/programs/web.browser.legacy/app/locales/

echo "Configuring secret"
bbb-conf --setsecret 1b6s1esKbXNM82ussxx8OHJTenNvfkBu59tkHHADvqk
bbb-conf --restart

echo "Cloning repos"
git clone https://github.com/Hamid-Najafi/DevOps-Notebook.git /root/DevOps-Notebook
git clone https://github.com/Hamid-Najafi/FontPack.git  /usr/share/fonts/FontPack
git clone https://github.com/Hamid-Najafi/bbb-download.git /root/bbb-download

echo "Setting favicon"
cp /root/DevOps-Notebook/Apps/BigBlueButton/Theme/Virgol/favicon.ico /var/www/bigbluebutton-default/favicon.ico

echo "Copying presentation PDFs"
cp /root/DevOps-Notebook/Apps/BigBlueButton/Theme/Virgol/Whiteboard-Virgol.pdf /var/www/bigbluebutton-default/default.pdf
find /root/DevOps-Notebook/Apps/BigBlueButton/Theme -type f -name "*.pdf" | xargs cp -t /var/www/bigbluebutton-default/

echo "Removing freeswitch sounds"
mv /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conferenceBackup

echo "Delete raw recordings older than 14 days script"
# sudo nano /etc/cron.daily/bigbluebutton
# # uncommenting the following line
# remove_raw_of_published_recordings

echo "Delete recordings older than 12 days script"
cp /root/DevOps-Notebook/Apps/BigBlueButton/Settings/bbb-recording-cleanup.sh /etc/cron.daily/bbb-recording-cleanup
chmod +x /etc/cron.daily/bbb-recording-cleanup

echo "Increase number of processes for nodejs"
sed -i 's/NUMBER_OF_BACKEND_NODEJS_PROCESSES=.*/NUMBER_OF_BACKEND_NODEJS_PROCESSES=4/g' /usr/share/meteor/bundle/bbb-html5-with-roles.conf
sed -i 's/NUMBER_OF_FRONTEND_NODEJS_PROCESSES=.*/NUMBER_OF_FRONTEND_NODEJS_PROCESSES=4/g' /usr/share/meteor/bundle/bbb-html5-with-roles.conf

echo "Increase number of recording workers"
mkdir -p /etc/systemd/system/bbb-rap-resque-worker.service.d
cat > n << EOF
[Service]
Environment=COUNT=16
EOF

# echo "Change recorded sessions processing time"
# mkdir -p /etc/systemd/system/bbb-rap-starter.timer.d
# cat > /etc/systemd/system/bbb-rap-starter.timer.d/override.conf << EOF
# [Timer]
# OnActiveSec=
# OnUnitInactiveSec=
# OnCalendar=19,20,21,22,23,00,01:*:00
# Persistent=false
# EOF

# BBB 2.2 - Ubuntu 16.04
# echo "Change recorded sessions processing time"
# mkdir -p /etc/systemd/system/bbb-record-core.timer.d
# cat > /etc/systemd/system/bbb-rap-starter.timer.d/override.conf << EOF
# [Timer]
# OnActiveSec=
# OnUnitInactiveSec=
# OnCalendar=19,20,21,22,23,00,01:*:00
# Persistent=false
# EOF

# systemctl list-timers --all
# systemctl enable bbb-rap-starter.service
# systemctl enable bbb-rap-resque-worker.service

systemctl daemon-reload
systemctl restart bbb-rap-resque-worker.service


echo "build font information cache files"
fc-cache -fv

echo "Configuring exporters"
echo "bbb-exporter"
cp -R /root/DevOps-Notebook/Apps/BigBlueButton/Monitoring/bbb-exporter /root/bbb-exporter 
sed -i 's|API_BASE_URL=.*|API_BASE_URL=https:\/\/'$1'\/bigbluebutton\/api\/|g' /root/bbb-exporter/secrets.env
docker-compose -f /root/bbb-exporter/docker-compose.yaml up -d

echo "node-exporter & cadvisor"
cp -R /root/DevOps-Notebook/Apps/Monitoring/Slave/ /root/monitoring
docker-compose -f /root/monitoring/docker-compose.yml up -d

echo "Applying NGINX_CONFIG"
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

echo "Configuring Nginx auth"
echo 'admin:$apr1$k98EN1wL$.4puamdnCPS46oGRDvRKx/' | tee /etc/nginx/.htpasswd
nginx -t &&  nginx -s reload

echo "Configuring Firewall"
ufw allow 9100
ufw allow 9338
ufw allow 9688

echo "Configuring bbb-download"
chmod u+x /root/bbb-download/install.sh
/root/bbb-download/install.sh 

echo "Configuring greenlight"
rm /etc/bigbluebutton/nginx/greenlight-redirect.nginx
sed -i 's/BIGBLUEBUTTON_SECRET=.*/BIGBLUEBUTTON_SECRET=1b6s1esKbXNM82ussxx8OHJTenNvfkBu59tkHHADvqk/g' /root/greenlight/.env
docker run --rm --env-file /root/greenlight/.env bigbluebutton/greenlight:v2 bundle exec rake conf:check
docker-compose -f /root/greenlight/docker-compose.yml up -d
docker exec greenlight-v2 bundle exec rake user:create["Admin","admin@vir-gol.ir","BBBpass.24","admin"]

echo "Disabling proxy"
export http_proxy=
export https_proxy=

while true; do
    read -p "System Reboot is recommended.[Yy/Nn]" yn
    case $yn in
        [Yy]* ) reboot;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo "Done!"
