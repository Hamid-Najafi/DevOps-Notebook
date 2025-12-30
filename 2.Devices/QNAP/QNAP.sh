# -------==========-------
# QNAP App
# -------==========-------
cd /share/CACHEDEV1_DATA/.qpkg/
ps -ef | grep -i Plex


# -------==========-------
# Plex
# -------==========-------
cd /share/CACHEDEV1_DATA/.qpkg/PlexMediaServer
sudo ./plex.sh start
chmod 644 "/share/CACHEDEV1_DATA/.qpkg/PlexMediaServer/Library/Plex Media Server/Preferences.xml"
