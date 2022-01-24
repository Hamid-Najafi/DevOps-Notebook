# -------==========-------
# Get new settings after update
# -------==========-------
export version=2.3.0-beta-3
export fqdnHost=ib2.vir-gol.ir
export user=root

mkdir /Users/hamid/Development/Software/DevOps-Notebook/Apps/BigBlueButton/Settings/$version/Orig
scp $user@$fqdnHost:/etc/nginx/sites-available/bigbluebutton  /Users/hamid/Development/Software/DevOps-Notebook/Apps/BigBlueButton/Settings/$version//Orig/bigbluebutton.nginx
scp $user@$fqdnHost:/usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties /Users/hamid/Development/Software/DevOps-Notebook/Apps/BigBlueButton/Settings/$version//Orig/bigbluebutton.properties
scp $user@$fqdnHost:/usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml /Users/hamid/Development/Software/DevOps-Notebook/Apps/BigBlueButton/Settings/$version//Orig/settings.yml

# Check if annything changed in new version:
https://www.diffchecker.com/diff


# echo "  - Prevent viewers from sharing webcams"
# sed -i 's/lockSettingsDisableCam=.*/lockSettingsDisableCam=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
https://native2ascii.net/
