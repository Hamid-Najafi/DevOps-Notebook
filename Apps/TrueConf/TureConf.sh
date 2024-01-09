# -------==========-------
# TureConf
# -------==========-------
# TrueConf Server is a powerful, high-quality and highly secured video conferencing software server. 
# It is specially designed to work with up to 1,600 participants in a multipoint conference over LAN or VPN networks.
#  TrueConf Server requires no hardware and includes client applications for all popular platforms, making it an easy-to-set up, unified communications solution.
# https://hub.docker.com/r/trueconf/trueconf-server
# https://trueconf.com/blog/knowledge-base/how-to-run-trueconf-server-in-a-docker-container.html
# -------==========-------
sudo docker run -d \
-p 80:80 -p 443:443 -p 4307:4307 \
-e ADMIN_USER=tc_admin \
-e ADMIN_PASSWORD=12345 \
trueconf/trueconf-server:stable

-v /home/$USER/trueconf/server/lib:/opt/trueconf/server/var/lib \

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


sudo touch /home/$USER/trueconf/server/lib/docker/passwd /home/$USER/trueconf/server/lib/docker/tcadmins /home/$USER/trueconf/server/lib/docker/tcsecadmins
sudo bash -c 'cat passwd >> /home/$USER/trueconf/server/lib/docker/passwd'
sudo bash -c 'echo new_admin >> /home/$USER/trueconf/server/lib/docker/tcadmins'

/home/root/trueconf/server/lib/docker/
new_admin:lD.TfLwKeGiQ2