# -------==========-------
# Get new settings after update
# -------==========-------
export version=2.3.0-beta-3
export fqdnHost=ib3.vir-gol.ir
export user=ubuntu

mkdir /Users/hamid/Development/Software/DevOps-Notebook/Apps/BigBlueButton/Settings/$version
scp $user@$fqdnHost:/etc/nginx/sites-available/bigbluebutton  /Users/hamid/Development/Software/DevOps-Notebook/Apps/BigBlueButton/Settings/$version/bigbluebutton.nginx
scp $user@$fqdnHost:/usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties /Users/hamid/Development/Software/DevOps-Notebook/Apps/BigBlueButton/Settings/$version/bigbluebutton.properties.orig
scp $user@$fqdnHost:/usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml /Users/hamid/Development/Software/DevOps-Notebook/Apps/BigBlueButton/Settings/$version/settings.yml.orig

# Check if annything changed in new version:
https://www.diffchecker.com/diff


# echo "  - Prevent viewers from sharing webcams"
# sed -i 's/lockSettingsDisableCam=.*/lockSettingsDisableCam=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
https://native2ascii.net/
