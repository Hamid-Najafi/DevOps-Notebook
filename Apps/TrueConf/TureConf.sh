# -------==========-------
# TureConf
# -------==========-------
# TrueConf Server is a powerful, high-quality and highly secured video conferencing software server. 
# It is specially designed to work with up to 1,600 participants in a multipoint conference over LAN or VPN networks.
#  TrueConf Server requires no hardware and includes client applications for all popular platforms, making it an easy-to-set up, unified communications solution.
# https://hub.docker.com/r/trueconf/trueconf-server
# https://trueconf.com/products/tcsf/trueconf-server-free.html
# -------==========-------
docker run \
-p 80:80 -p 443:443 -p 4307:4307 \
-e ADMIN_USER=tc_admin \
-e ADMIN_PASSWORD=12345 \
-e INIT_DB=false \
-v /home/$USER/trueconf/server/lib:/opt/trueconf/server/var/lib \
-v /home/$USER/trueconf/server/log:/opt/trueconf/server/var/log \
-d trueconf/trueconf-server:stable

-v /path/to/custom/certs:/ssl

username: tc_admin
password: 12345