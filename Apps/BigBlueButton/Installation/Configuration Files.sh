# -------==========-------
#  BBB_WEB_CONFIG
# -------==========-------
/usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
# -------==========-------
#  .HTML5 client
# -------==========-------
/usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml
# -------==========-------
#  virtual-backgrounds
# -------==========-------
/usr/share/meteor/bundle/programs/server/assets/app/resources/images/virtual-backgrounds
# -------==========-------
#  .Nginx
# -------==========-------
/etc/nginx/sites-available/bigbluebutton 
# -------==========-------
#  .Red5 (bbb-web)
# -------==========-------
/usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
# -------==========-------
#  Locales
# -------==========-------
# BBB-2.3
(Both are same)
/usr/share/meteor/bundle/programs/web.browser/app/locales/
/usr/share/meteor/bundle/programs/web.browser.legacy/app/locales/
# -------==========-------
#  .Flash (SWF) client
# -------==========-------
/var/www/bigbluebutton/client/conf/config.xml
# -------==========-------
#  .FreeSWITCH
# -------==========-------
# Playback settings
/opt/freeswitch/etc/freeswitch/autoload_configs/conference.conf.xml
      <!-- File to play to acknowledge muted -->
      <!--param name="muted-sound" value="conference/conf-muted.wav"/> -->
      <!-- File to play to acknowledge unmuted -->
      <!--param name="unmuted-sound" value="conference/conf-unmuted.wav"/> -->
      <!-- File to play if you are alone in the conference -->
      <!--param name="alone-sound" value="conference/conf-alone.wav"/> -->

# Audio Files:
/opt/freeswitch/share/freeswitch/sounds/en/us/callie
# Other Config files
/opt/freeswitch/conf/vars.xml
/opt/freeswitch/etc/freeswitch/sip_profiles/external.xml 
# -------==========-------
# .Record and playback
# -------==========-------
/usr/local/bigbluebutton/core/scripts/bigbluebutton.yml 
# -------==========-------
# .sip.nginx
# -------==========-------
/etc/bigbluebutton/nginx/sip.nginx 
# -------==========-------
# .Kurento SFU
# -------==========-------
/usr/local/bigbluebutton/bbb-webrtc-sfu/config/default.yml