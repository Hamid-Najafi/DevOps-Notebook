# -------==========-------
# Get new settings after update
# -------==========-------
mkdir /Users/hamid/Development/Software/DevOps-Notebook/Apps/BigBlueButton/Settings/2.2.30
scp ubuntu@ib2.legace.ir:/etc/nginx/sites-available/bigbluebutton  /Users/hamid/Development/Software/DevOps-Notebook/Apps/BigBlueButton/Settings/2.2.30/bigbluebutton.nginx
scp ubuntu@ib2.legace.ir:/usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties /Users/hamid/Development/Software/DevOps-Notebook/Apps/BigBlueButton/Settings/2.2.30/bigbluebutton.properties.orig
scp ubuntu@ib2.legace.ir:/usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml /Users/hamid/Development/Software/DevOps-Notebook/Apps/BigBlueButton/Settings/2.2.30/settings.yml.orig

# Check if annything changed in new version:
https://www.diffchecker.com/diff


# echo "  - Prevent viewers from sharing webcams"
# sed -i 's/lockSettingsDisableCam=.*/lockSettingsDisableCam=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
https://native2ascii.net/
