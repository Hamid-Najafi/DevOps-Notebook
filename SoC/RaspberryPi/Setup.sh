apt install resolvconf && echo -e "nameserver 185.51.200.2\nnameserver 178.22.122.100" | tee -a /etc/resolvconf/resolv.conf.d/head && service resolvconf restart
# -------==========-------
# Set Hostname
# -------==========-------
export hostname=C1TechHMS
sudo hostnamectl set-hostname C1TechHMS
echo -e "127.0.0.1 C1TechHMS" | tee -a /etc/hosts


sudo reboot
sudo apt-get update
sudo apt-get upgrade -y
