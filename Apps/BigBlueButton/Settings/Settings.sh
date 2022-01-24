# -------==========-------
# Get new settings after update
# -------==========-------
export version=2.4.2
export fqdnHost=b2.vir-gol.ir
export user=root

mkdir -p /Users/hamid/Development/Software/DevOps-Notebook/Apps/BigBlueButton/Settings/Versions/$version/Orig
scp $user@$fqdnHost:/etc/nginx/sites-available/bigbluebutton  /Users/hamid/Development/Software/DevOps-Notebook/Apps/BigBlueButton/Settings/Versions/$version//Orig/bigbluebutton.nginx
scp $user@$fqdnHost:/usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties /Users/hamid/Development/Software/DevOps-Notebook/Apps/BigBlueButton/Settings/Versions/$version//Orig/bigbluebutton.properties
scp $user@$fqdnHost:/usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml /Users/hamid/Development/Software/DevOps-Notebook/Apps/BigBlueButton/Settings/Versions/$version//Orig/settings.yml
scp $user@$fqdnHost:/usr/share/meteor/bundle/programs/web.browser/app/locales/fa_IR.json /Users/hamid/Development/Software/DevOps-Notebook/Apps/BigBlueButton/Settings/Versions/$version/Orig/
# Check if annything changed in new version:
https://www.diffchecker.com/diff


# echo "  - Prevent viewers from sharing webcams"
# sed -i 's/lockSettingsDisableCam=.*/lockSettingsDisableCam=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
https://native2ascii.net/
