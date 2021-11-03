# Manual
https://michlstechblog.info/blog/raspberry-pi-eibknx-ip-gateway-and-router-with-knxd/

# Repo location
/mnt/c/Users/golde/OneDrive/Documents/GitHub/knxd

# ============================================================ #
# Ubuntu APT
sudo apt install knxd knxd-tools

sudo apt remove knxd knxd-tools
sudo apt autoclean && sudo apt autoremove
# ============================================================ #
wget https://raw.githubusercontent.com/Hamid-Najafi/DevOps-Notebook/master/Apps/knxd/install_knxd_systemd.sh
chmod +x install_knxd_systemd.sh
sudo ./install_knxd_systemd.sh
# ============================================================ #
# Manual Build
# first, install build tools and dependencies. You need git, autotools, and gcc/g++.
apt-get update
sudo apt-get install -y git-core autotools-dev  build-essential pkg-config libtool libsystemd-dev libusb-1.0-0-dev cmake libev-dev  dh-systemd 

sudo apt-get install debhelper cdbs manpages-dev autoconf automake libtool libusb-1.0-0-dev git-core build-essential libsystemd-dev dh-systemd  cmake
# You also need a "knxd" user.
sudo useradd -s /usr/sbin/nologin -m -d /var/lib/knxd-custom knxd-custom  
#? sudo passwd knxd-custom

# get the source code
cd ~
git clone https://github.com/knxd/knxd.git

# build+install knxd
cd knxd
git checkout debian
sh bootstrap.sh
./configure --help
./configure --your-chosen-options

./configure \
--build=x86 \
--host=x86 \
--target=x86 \
--enable-ft12 \
--enable-dummy \
--enable-tpuart \
--enable-eibnetip \
--enable-eibnetserver \
--enable-eibnetiptunnel \
--enable-usb \
--enable_systemd \
--prefix=/usr

# --enable-java	

sudo make -j4
sudo make install
cd ..

# Now switch to the "knxd" user and start the daemon.
# ============================================================ #

# Executable file location
/usr/bin/knxd
/usr/bin/knxtool

# Config location
nano /etc/knxd.conf

# Service location
/etc/systemd/system/multi-user.target.wants/knxd.service
