# -------==========------- 
# Install Apache2
# -------==========------- 
sudo apt-get install -y apache2 apache2-doc apache2-utils

 sudo apachectl configtest    

# -------==========-------
# Confs
# -------==========-------
sudo nano /etc/apache2/sites-available/hamid-najafi.conf
sudo nano /etc/apache2/sites-available/hamid-najafi-le-ssl.conf
sudo nano /etc/apache2/sites-available/reverse-Proxy.conf 
sudo nano /etc/apache2/sites-available/reverse-Proxy-le-ssl.conf

sudo a2ensite reverse-Proxy-le-ssl.conf 
sudo a2ensite reverse-Proxy.conf 
sudo a2ensite hamid-najafi.conf
sudo a2ensite hamid-najafi-le-ssl.conf
# -------==========-------
# Modes
# -------==========-------
sudo a2enmod proxy proxy_ajp proxy_http rewrite deflate headers proxy_balancer proxy_connect proxy_html lbmethod_byrequests xml2enc    
# Enable PHP Module in Apache2
sudo apt-get install libapache2-mod-php
# -------==========------- 
# Uninstall Apache2
# -------==========------- 
sudo apt-get remove apache2 apache2-utils apache2.2-bin apache2-common
sudo apt-get autoremove --purge
cat << "EOF" > ${OVPN_DIR}/${OVPN_ID}.conf