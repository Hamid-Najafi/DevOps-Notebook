# -------==========-------
# BBB Install Script
# -------==========-------
https://github.com/bigbluebutton/bbb-install

# ** Ubuntu 16.04 **
wget -qO- https://ubuntu.bigbluebutton.org/bbb-install.sh | sudo bash -s -- -v xenial-22 -s ib1.legace.ir -e admin@legace.ir -w 
-g
wget -qO- https://ubuntu.bigbluebutton.org/bbb-install.sh | sudo bash -s -- -v xenial-22 -s 3b.legace.ir -e admin@legace.ir -w -a -g -c turn.legace.ir:TurnSecret.24
# ** Ubuntu 18.04 **
wget -qO- https://ubuntu.bigbluebutton.org/bbb-install.sh | sudo bash -s -- -v bionic-230-dev -s 3b.legace.ir -e admin@legace.ir -w -g
-a -g
wget -qO- https://ubuntu.bigbluebutton.org/bbb-install.sh | sudo bash -s -- -v bionic-230-dev -s 3b.legace.ir -e admin@legace.ir -w -a -g -c turn.legace.ir:TurnSecret.24

# -g -a
-s : hostname
-v : version
-a : API Demo
-w : UFW, it will ENABLE UWF and make its rule
-g : Greenlight
# -------==========-------
# TURN server Install Script
# -------==========------- 
wget -qO- https://ubuntu.bigbluebutton.org/bbb-install.sh | bash -s -- -c <FQDN>:<SECRET> -e <EMAIL>
wget -qO- https://ubuntu.bigbluebutton.org/bbb-install.sh | bash -s -- -c turn.legace.ir:TurnSecret.24 -e admin@legace.ir
# -------==========-------
# Greenlight Install Script
# -------==========------- 
wget -qO- https://ubuntu.bigbluebutton.org/bbb-install.sh | sudo bash -s -- -v bionic-230-dev -s 3b.legace.ir -e admin@legace.ir -w -g 
# -a
cd greenlight/
docker exec greenlight-v2 bundle exec rake admin:create
# -------==========-------
# Demo API
# -------==========------- 
# Demo API only works when nothing redirects root location /
sudo apt-get install bbb-demo
sudo apt-get remove bbb-demo
# Secret Location
# Version 2.2
sudo nano /var/lib/tomcat7/webapps/demo/bbb_api_conf.jsp
# Version 2.3
sudo nano /var/lib/tomcat8/webapps/demo/bbb_api_conf.jsp
# -------==========------- 
# Errors
# -------==========------- 
# Not running: LibreOffice
sudo apt-get install openjdk-8-jdk
# Select openjdk-8-jdk
sudo update-alternatives --config java
# -------==========------- 
# Uninstall Apache2
sudo apt-get remove apache2 apache2-utils apache2.2-bin apache2-common
sudo apt-get autoremove --purge
# -------==========-------
# Uninstall Script
# -------==========-------
apt install python3
wget https://raw.githubusercontent.com/strongpapazola/uninstall_bigbluebutton/master/uninstall_package.py
python3 uninstall_package.py