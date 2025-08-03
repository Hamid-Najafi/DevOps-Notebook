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
yq w -i $HTML5_CONFIG public.app.copyright '©2022 Virgol Inc. Powerd by BigBlueButton' 
yq w -i $HTML5_CONFIG public.app.helpLink https://panel.vir-gol.ir/video/guide-pr
yq w -i $HTML5_CONFIG public.app.remainingTimeAlertThreshold 10
yq w -i $HTML5_CONFIG public.app.defaultSettings.application.chatPushAlerts true
yq w -i $HTML5_CONFIG public.app.defaultSettings.application.userJoinPushAlerts true
yq w -i $HTML5_CONFIG public.app.defaultSettings.application.overrideLocale fa_IR
yq w -i $HTML5_CONFIG public.caption.enabled false
yq w -i $HTML5_CONFIG public.virtualBackgrounds.enabled false

echo "-----------------------"
echo "Applying BBB_WEB_CONFIG"
echo "-----------------------"
sed -i 's/numConversionThreads=.*/numConversionThreads=10/g' $BBB_WEB_CONFIG
sed -i 's/defaultWelcomeMessage=.*/defaultWelcomeMessage=\\u062c\\u0647\\u062a \\u0641\\u0639\\u0627\\u0644 \\u0633\\u0627\\u0632\\u06cc \\u0645\\u06cc\\u06a9\\u0631\\u0648\\u0641\\u0646 \\u06cc\\u0627 \\u062f\\u0648\\u0631\\u0628\\u06cc\\u0646 \\u0627\\u0632 \\u0634\\u062e\\u0635 \\u0627\\u0631\\u0627\\u0626\\u0647 \\u062f\\u0647\\u0646\\u062f\\u0647 \\u06cc\\u0627 \\u062f\\u0628\\u06cc\\u0631 \\u062f\\u0631\\u062e\\u0648\\u0627\\u0633\\u062a \\u06a9\\u0646\\u06cc\\u062f \\u0628\\u0627 \\u06a9\\u0644\\u06cc\\u06a9 \\u0631\\u0648\\u06cc \\u0646\\u0627\\u0645 \\u0634\\u0645\\u0627\\u060c \\u0642\\u0641\\u0644 \\u06a9\\u0627\\u0631\\u0628\\u0631 \\u0634\\u0645\\u0627 \\u0631\\u0627 \\u063a\\u06cc\\u0631\\u0641\\u0639\\u0627\\u0644 \\u06a9\\u0646\\u062f \\u062c\\u0647\\u062a \\u062c\\u0644\\u0648\\u06af\\u06cc\\u0631\\u06cc \\u0627\\u0632 \\u062a\\u062f\\u0627\\u062e\\u0644 \\u0635\\u062f\\u0627 \\u0648 \\u0646\\u0648\\u06cc\\u0632 \\u0644\\u0637\\u0641\\u0627 \\u0627\\u0632 \\u0647\\u062f\\u0633\\u062a \\u0627\\u0633\\u062a\\u0641\\u0627\\u062f\\u0647 \\u06a9\\u0646\\u06cc\\u062f./g' $BBB_WEB_CONFIG
sed -i 's/defaultWelcomeMessageFooter=.*/defaultWelcomeMessageFooter=\\u062c\\u0647\\u062a \\u0641\\u0639\\u0627\\u0644 \\u0633\\u0627\\u0632\\u06cc \\u0645\\u06cc\\u06a9\\u0631\\u0648\\u0641\\u0646 \\u06cc\\u0627 \\u062f\\u0648\\u0631\\u0628\\u06cc\\u0646 \\u0627\\u0632 \\u0634\\u062e\\u0635 \\u0627\\u0631\\u0627\\u0626\\u0647 \\u062f\\u0647\\u0646\\u062f\\u0647 \\u06cc\\u0627 \\u062f\\u0628\\u06cc\\u0631 \\u062f\\u0631\\u062e\\u0648\\u0627\\u0633\\u062a \\u06a9\\u0646\\u06cc\\u062f \\u0628\\u0627 \\u06a9\\u0644\\u06cc\\u06a9 \\u0631\\u0648\\u06cc \\u0646\\u0627\\u0645 \\u0634\\u0645\\u0627\\u060c \\u0642\\u0641\\u0644 \\u06a9\\u0627\\u0631\\u0628\\u0631 \\u0634\\u0645\\u0627 \\u0631\\u0627 \\u063a\\u06cc\\u0631\\u0641\\u0639\\u0627\\u0644 \\u06a9\\u0631\\u062f\\u0647 \\u0648 \\u0628\\u0627 \\u0627\\u062a\\u0645\\u0627\\u0645 \\u0646\\u06cc\\u0627\\u0632 \\u062c\\u0647\\u062a \\u062c\\u0644\\u0648\\u06af\\u06cc\\u0631\\u06cc \\u0627\\u0632 \\u0642\\u0637\\u0639\\u06cc \\u0635\\u062f\\u0627 \\u062d\\u062a\\u0645\\u0627 \\u0642\\u0641\\u0644 \\u0628\\u0627\\u0632\\u06af\\u0631\\u062f\\u0627\\u0646\\u062f\\u0647 \\u0634\\u0648\\u062f. \\u000a\\u000d \\u0647\\u0645\\u0686\\u0646\\u06cc\\u0646 \\u0627\\u0645\\u06a9\\u0627\\u0646 \\u06af\\u0641\\u062a\\u200c\\u0648\\u200c\\u06af\\u0648\\u06cc \\u062e\\u0635\\u0648\\u0635\\u06cc \\u063a\\u06cc\\u0631\\u0641\\u0639\\u0627\\u0644 \\u0628\\u0648\\u062f\\u0647 \\u0648 \\u062a\\u0646\\u0647\\u0627 \\u06af\\u0641\\u062a\\u200c\\u0648\\u200c\\u06af\\u0648\\u06cc \\u0639\\u0645\\u0648\\u0645\\u06cc \\u062f\\u0631 \\u062f\\u0633\\u062a\\u0631\\u0633 \\u0627\\u0633\\u062a. \\u000a\\u000d \\u062c\\u0647\\u062a \\u062c\\u0644\\u0648\\u06af\\u06cc\\u0631\\u06cc \\u0627\\u0632 \\u062a\\u062f\\u0627\\u062e\\u0644 \\u0635\\u062f\\u0627 \\u0648 \\u0646\\u0648\\u06cc\\u0632 \\u0644\\u0637\\u0641\\u0627 \\u0627\\u0632 \\u0647\\u062f\\u0633\\u062a \\u0627\\u0633\\u062a\\u0641\\u0627\\u062f\\u0647 \\u06a9\\u0646\\u06cc\\u062f./g' $BBB_WEB_CONFIG
sed -i 's/defaultMaxUsers=.*/defaultMaxUsers=150/g' $BBB_WEB_CONFIG
sed -i 's/meetingExpireIfNoUserJoinedInMinutes=.*/meetingExpireIfNoUserJoinedInMinutes=1440/g' $BBB_WEB_CONFIG
sed -i 's/meetingExpireWhenLastUserLeftInMinutes=.*/meetingExpireWhenLastUserLeftInMinutes=1440/g' $BBB_WEB_CONFIG
sed -i 's/breakoutRoomsEnabled=.*/breakoutRoomsEnabled=false/g' $BBB_WEB_CONFIG
sed -i 's/lockSettingsDisablePrivateChat=.*/lockSettingsDisablePrivateChat=true/g' $BBB_WEB_CONFIG
sed -i 's/lockSettingsDisableNote=.*/lockSettingsDisableNote=true/g' $BBB_WEB_CONFIG
sed -i 's/lockSettingsLockOnJoin=.*/lockSettingsLockOnJoin=false/g' $BBB_WEB_CONFIG
sed -i 's/lockSettingsLockOnJoinConfigurable=.*/lockSettingsLockOnJoinConfigurable=true/g' $BBB_WEB_CONFIG
sed -i 's/allowDuplicateExtUserid=.*/allowDuplicateExtUserid=false/g' $BBB_WEB_CONFIG

echo "-------------------------------------"
echo "Optimize NodeJS (If 16GB RAM or more)"
echo "-------------------------------------"
sed -i 's/--max-old-space-size=2048/--max-old-space-size=4096/g' /usr/share/meteor/bundle/systemd_start.sh
service bbb-html5 restart

echo "---------------"
echo "ReCloning repos"
echo "---------------"
cd /root/DevOps-Notebook && git pull
cd /usr/share/fonts/FontPack && git pull

echo "-------------------------------"
echo "Installing Persian translations"
echo "-------------------------------"
# cp /usr/share/meteor/bundle/programs/web.browser/app/locales/fa_IR.json{,.backup}
# cp /usr/share/meteor/bundle/programs/web.browser.legacy/app/locales/fa_IR.json{,.backup}
# cp /root/DevOps-Notebook/Apps/BigBlueButton/Settings/fa_IR.json /usr/share/meteor/bundle/programs/web.browser/app/locales/
# cp /root/DevOps-Notebook/Apps/BigBlueButton/Settings/fa_IR.json /usr/share/meteor/bundle/programs/web.browser.legacy/app/locales/

echo "---------------"
echo "Setting favicon"
echo "---------------"
cp /root/DevOps-Notebook/Apps/BigBlueButton/Theme/Virgol/favicon.ico /var/www/bigbluebutton-default/favicon.ico

echo "-------------------------"
echo "Copying presentation PDFs"
echo "-------------------------"
cp /root/DevOps-Notebook/Apps/BigBlueButton/Theme/Virgol/Whiteboard-Virgol.pdf /var/www/bigbluebutton-default/default.pdf
find /root/DevOps-Notebook/Apps/BigBlueButton/Theme -type f -name "*.pdf" | xargs cp -t /var/www/bigbluebutton-default/

echo "---------------------------------------"
echo "Increase number of processes for nodejs"
echo "---------------------------------------"
sed -i 's/NUMBER_OF_BACKEND_NODEJS_PROCESSES=.*/NUMBER_OF_BACKEND_NODEJS_PROCESSES=4/g' /usr/share/meteor/bundle/bbb-html5-with-roles.conf
sed -i 's/NUMBER_OF_FRONTEND_NODEJS_PROCESSES=.*/NUMBER_OF_FRONTEND_NODEJS_PROCESSES=4/g' /usr/share/meteor/bundle/bbb-html5-with-roles.conf

echo "--------------"
echo "Restarting BBB"
echo "--------------"
bbb-conf --restart

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

echo "----------------"
echo "Restarting NGINX"
echo "----------------"
nginx -t &&  nginx -s reload

echo "Done!"