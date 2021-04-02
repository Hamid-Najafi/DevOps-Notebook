# -------==========-------
# Get new settings after update
# -------==========-------
mkdir /Users/hamid/Development/Software/DevOps-Notebook/Apps/BigBlueButton/Settings/2.3-beta-2
scp root@ib2.vir-gol.ir:/etc/nginx/sites-available/bigbluebutton  /Users/hamid/Development/Software/DevOps-Notebook/Apps/BigBlueButton/Settings/2.3-beta-2/bigbluebutton.nginx
scp root@ib2.vir-gol.ir:/usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties /Users/hamid/Development/Software/DevOps-Notebook/Apps/BigBlueButton/Settings/2.3-beta-2/bigbluebutton.properties.orig
scp root@ib2.vir-gol.ir:/usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml /Users/hamid/Development/Software/DevOps-Notebook/Apps/BigBlueButton/Settings/2.3-beta-2/settings.yml.orig

# Check if annything changed in new version:
https://www.diffchecker.com/diff


# echo "  - Prevent viewers from sharing webcams"
# sed -i 's/lockSettingsDisableCam=.*/lockSettingsDisableCam=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
https://native2ascii.net/
