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

sudo apt install avahi-daemon 

# -------==========-------
# PI Power Button
# -------==========-------
# https://github.com/Howchoo/pi-power-button
# -------==========-------
git clone https://github.com/Howchoo/pi-power-button.git
./pi-power-button/script/install

# -------==========-------
# Setup Wifi AP
# -------==========-------
1. Install & Config hostapd (Configure the AP Hotspot)
2. Install & Config dnsmasq (Configure the DHCP Server)
3. Config dhcpcd (Configure a Static IP for the Wlan0 Interface)

# -------==========-------
# Customize the Raspberry Pi Splash Screen
# -------==========-------

# https://www.hackster.io/kamaluddinkhan/changing-the-splash-screen-on-your-raspberry-pi-7aee31
 
sudo nano /etc/systemd/system/splashscreen.service

[Unit]
Description=Splash screen
DefaultDependencies=no
After=local-fs.target
[Service]
ExecStart=/usr/bin/fbi -d /dev/fb0 --noverbose -a /home/pi/c1-tech.png
StandardInput=tty
StandardOutput=tty
[Install]
WantedBy=sysinit.target

systemctl daemon-reload
sudo systemctl enable splashscreen.service
sudo systemctl start splashscreen.service


# -------==========-------
# NET 6.0 SDK (v6.0.402)
# -------==========-------
curl -sSL https://dot.net/v1/dotnet-install.sh | bash
echo 'export DOTNET_ROOT=$HOME/.dotnet' >> ~/.bashrc
echo 'export PATH=$PATH:$HOME/.dotnet' >> ~/.bashrc
source ~/.bashrc
dotnet --version