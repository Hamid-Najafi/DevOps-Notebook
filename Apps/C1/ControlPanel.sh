# -------==========-------
# Ubuntu Server 22.04.01
# Hostname: orcp6-5
# Username: c1tech
# Password: 1478963
# -------==========-------
# Run This Script
# wget -qO- https://raw.githubusercontent.com/Hamid-Najafi/C1-Control-Panel/main/ControlPanel-Install.sh | sudo bash -s --
# -------==========-------
# Config Openssh on System
apt install openssh-server
systemctl enable ssh --now
# -------==========-------
# Pre-Requirements
sudo su
apt update && apt upgrade -y
apt install -y software-properties-common git avahi-daemon python3-pip 
apt install -y debhelper build-essential gcc g++ gdb cmake 
# -------==========-------
apt install -y mesa-common-dev libfontconfig1 libxcb-xinerama0 libglu1-mesa-dev
apt install -y qtbase5-dev qt5-qmake libqt5quickcontrols2-5 libqt5virtualkeyboard5*  libqt5webengine5 qtmultimedia5* libqt5serial*  libqt5multimedia*   qtwebengine5-dev libqt5svg5-dev libqt5qml5 libqt5quick5  qttools5*
apt install -y qml-module-qtquick* qml-module-qt-labs-settings qml-module-qtgraphicaleffects
# apt install -y qtcreator
# add-apt-repository ppa:beineri/opt-qt-5.15.4-focal
# apt update
# apt-get install qt515-meta-minimal -y
# apt-get install qt515-meta-full -y
# export LD_LIBRARY_PATH=/opt/qt515/lib/
# -------==========-------
# Music & Voice Command
apt install -y portaudio19-dev libportaudio2 libportaudiocpp0
apt install libasound2-dev libpulse-dev gstreamer1.0-omx-* gstreamer1.0-alsa gstreamer1.0-plugins-good libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev 
pip3 install sounddevice vosk
apt install -y alsa alsa-tools alsa-utils
#alsamixer
# -------==========-------
usermod -a -G dialout c1tech
usermod -a -G video c1tech
usermod -a -G audio c1tech
# -------==========-------
# PJSIP
git clone https://github.com/pjsip/pjproject.git
cd pjproject
./configure --prefix=/usr --enable-shared
make dep -j4 
make -j4
make install
# Update shared library links.
ldconfig
# Verify that pjproject has been installed in the target location
ldconfig -p | grep pj
# -------==========-------
# USB Auto Mount
apt install liblockfile-bin liblockfile1 lockfile-progs
git clone https://github.com/rbrito/usbmount
apt install  build-essential
cd usbmount
dpkg-buildpackage -us -uc -b
cd ..
dpkg -i usbmount_0.0.24_all.deb
# -------==========-------
# Setup Application
git clone https://github.com/Hamid-Najafi/C1-Control-Panel.git
mv C1-Control-Panel/C1 .
cd C1-Control-Panel/Panel
touch -r *.*
qmake
make -j4 
# -------==========-------
# Create Service for App
journalctl --vacuum-time=60d
cat > /etc/systemd/system/orcp.service << "EOF"
[Unit]
Description=C1Tech Operating Room Control Panel V2.0

[Service]
ExecStart=/bin/bash -c '/home/c1tech/C1-Control-Panel/Panel/panel -platform eglfs'
Restart=always
User=c1tech
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable orcp --now
systemctl restart orcp
# journalctl -u orcp -f
# -------==========-------
# Splash Screen
nano  /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
update-grub

apt -y autoremove --purge plymouth
apt -y install plymouth plymouth-themes
# By default ubuntu-text is active 
# /usr/share/plymouth/themes/ubuntu-text/ubuntu-text.plymouth
# We Will use bgrt (which is same as spinner but manufacture logo is enabled) theme with our custom logo
cp /usr/share/plymouth/themes/spinner/bgrt-fallback.png{,.bak}
cp /usr/share/plymouth/themes/spinner/watermark.png{,.bak}
cp /usr/share/plymouth/ubuntu-logo.png{,.bak}
cp C1-Control-Panel/bgrt-c1.png /usr/share/plymouth/themes/spinner/bgrt-fallback.png
cp C1-Control-Panel/watermark-empty.png /usr/share/plymouth/themes/spinner/watermark.png
cp C1-Control-Panel/watermark-empty.png /usr/share/plymouth/ubuntu-logo.png
update-initramfs -u
# update-alternatives --list default.plymouth
# update-alternatives --display default.plymouth
# update-alternatives --config default.plymouth
# -------==========-------
init 6