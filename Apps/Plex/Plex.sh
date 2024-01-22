# -------==========-------
# PLEX
# -------==========-------

(1900/UDP, 32400/TCP, 32410/UDP, 32412/UDP, 32413/UDP, 32414/UDP, 32469/TCP, and 8324/TCP) 

https://github.com/plexinc/pms-docker/tree/master

docker run \
-d \
–name plex \
–network=host \
-e TZ=”” \
-e PLEX_CLAIM=”” \
-v /plex/database:/config \
-v /plex/transcode:/transcode \
-v /plex/media:/data \
plexinc/pms-docker