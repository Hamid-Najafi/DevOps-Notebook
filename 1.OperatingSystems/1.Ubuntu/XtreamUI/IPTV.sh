# -------==========-------
# Xtream-Ui
# -------==========-------
# System Needs 16GB of RAM (MariaDB Needs 12GB)

sudo apt update && rm -rf install.py && wget -qO install.py https://raw.githubusercontent.com/masoudgb/Xtream-Ui/main/install.py && sudo python3 install.py


https://lofertech.com/xtream-ui-installation/
sudo apt update && rm -rf install.py && wget -qO install.py https://raw.githubusercontent.com/masoudgb/Xtream-Ui/main/install.py && sudo python3 install.py

# Credentials
cat /root/credentials.txt
user_iptvpro


# -------==========-------
# Start Service
# -------==========-------
/etc/init.d/xtreamcodes --> sudo /home/xtreamcodes/iptv_xtream_codes/start_services.sh 
ps aux | grep xtream

# -------==========-------
# Logs
# -------==========-------
ps aux | grep -i xtream
cat /home/xtreamcodes/iptv_xtream_codes/logs/error.log
sudo systemctl stop xtreamcodes

# -------==========-------
# Remove
# -------==========-------
# MariaDB
sudo systemctl status mysql
sudo systemctl stop mysql
sudo apt-get remove --purge mariadb-server mariadb-client mariadb-common -y
sudo apt-get autoremove -y
sudo apt-get autoclean
sudo rm -rf /etc/mysql /var/lib/mysql /var/log/mysql*
sudo rm -rf /var/run/mysqld
sudo rm -rf /usr/share/keyrings/mariadb-archive-keyring.gpg

sudo pkill -f start_services.sh
sudo pkill -f nginx_rtmp
sudo pkill -f nginx
sudo pkill -f php-fpm

sudo update-rc.d -f xtreamcodes remove
sudo rm -f /etc/init.d/xtreamcodes
ps aux | grep xtream

sudo chattr -i /home/xtreamcodes/iptv_xtream_codes/GeoLite2.mmdb
sudo umount /home/xtreamcodes/iptv_xtream_codes/tmp
sudo umount /home/xtreamcodes/iptv_xtream_codes/streams
sudo rm -rf /home/xtreamcodes

sudo userdel xtreamcodes

# -------==========-------
# Channels
# -------==========-------
https://iptv-org.github.io
https://www.iptv-playlist.space/
https://chillhop.webflow.io/releases/chillhop-timezones-nigeria/v1
