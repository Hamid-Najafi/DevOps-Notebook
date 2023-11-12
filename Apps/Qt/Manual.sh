#!/bin/bash -e

# Copyleft (c) 2022.
# -------==========-------
# QT from Online Installer
# -------==========-------
# https://wiki.qt.io/Online_Installer_4.x#Selecting_a_mirror_for_opensource
# Using third-party mirror
installer(.run/exe) --mirror https://mirrors.ocf.berkeley.edu/qt # (best)
installer(.run/exe) --mirror http://www.nic.funet.fi/pub/mirrors/download.qt-project.org
installer(.run/exe) --mirror http://ftp2.nluug.nl/languages/qt
maintenancetool(.run/exe)  --mirror http://qt.mirror.constant.com
# -------==========-------
# QT5 from APT
# -------==========-------
apt install -q -y build-essential gcc
apt install -q -y mesa-common-dev libfontconfig1 libxcb-xinerama0 libglu1-mesa-dev 
apt install -q -y qt5* qttools5* qtmultimedia5* qtwebengine5* qtvirtualkeyboard* qtdeclarative* qt3d*
apt install -q -y qtbase5* 
apt install -q -y libqt5*
apt install -q -y qml-module*
# -------==========-------
# QT5 Compile Source
# -------==========-------
make distclean
touch -r *.*
qmake
make -j2

# -------==========-------
# QT6 from APT
# -------==========-------
apt install -q -y build-essential gcc g++ gdb cmake ninja-build 
apt install -q -y mesa-common-dev libfontconfig1 libxcb-xinerama0 libglu1-mesa-dev 
apt install -q -y qt6* libqt6* qml6*
# -------==========-------
# QT6 Compile Source
# -------==========-------
cmake --build . --target clean
cmake -G Ninja .
cmake --build . --parallel 2

# -------==========-------
# Build from Source
# -------==========-------
# Image: Ubuntu Bare: https://github.com/Qengineering/Jetson-Nano-Ubuntu-20-image
# Hostname: nano
# Username: jetson
# Password: jetson
# -------==========-------
# Allocate free space to ext4 pations
# -------==========-------
sudo apt install -y -q gparted
sudo gparted
df -h
# Increase SWAP Partition
sudo swapoff -a
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
htop
sudo apt update && sudo apt upgrade -y
# -------==========-------
# Required
# -------==========-------
export DEBIAN_FRONTEND=noninteractive

sudo apt install -y -q screen atop htop build-essential ninja-build  python-is-python3 python3 \
libdbus-1-dev libicu-dev libinput-dev libpng-dev libjpeg-dev libglib2.0-dev libopengl-dev libmd4c* \
libosmesa6 mesa-utils libegl1-mesa-dev libglu1-mesa-dev libgl1-mesa-dev  \
pkg-config openssl libssl-dev libts-dev libglapi-mesa libhunspell-dev \
libudev-dev freeglut3 freeglut3-dev mesa-common-dev libglew-dev libglfw3-dev libglm-dev libao-dev libmpg123-dev \
libboost-all-dev libmtdev-dev  libsrtp2-dev libsnappy-dev ruby libbz2-dev libatkmm-1.6-dev libxi6 libxcomposite1 \
libavcodec-dev libavformat-dev libswscale-dev freetds-dev libiodbc2-dev firebird-dev libgst-dev

# Graphics driver options
# Use VC4 driver instead of Broadcom EGL binary-blobs. Mandatory on Raspberry Pi 4
sudo apt install -y -q libgles2-mesa-dev libgbm-dev libdrm-dev	
# Vulkan driver. Only on Raspberry Pi 4
sudo apt install -y -q libvulkan-dev vulkan-tools vulkan-utils	 
# Bluetooth
sudo apt install -y -q bluez libbluetooth-dev
# gstreamer multimedia framework support
sudo apt install -y -q gstreamer1.0-omx libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-plugins-bad libgstreamer-plugins-bad1.0-dev gstreamer1.0-pulseaudio gstreamer1.0-tools gstreamer1.0-alsa
# Linux ALSA Audio support
sudo apt install -y -q libasound2-dev
# WebEngine (Also Install X11 support)
sudo apt install -y -q flex bison gperf ubuntu-restricted-extras libre2-dev libnss3 libnss3-dev libdrm-dev  libxml2-dev libxslt-dev libxslt1-dev libminizip-dev libjsoncpp-dev liblcms2-dev libevent-dev libprotobuf-dev protobuf-compiler libopus-dev libvpx-dev libxcomposite-dev libxshmfence-dev libxshmfence1
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
cat << EOF | tee -a  ~/.profile
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
EOF
source ~/.profile
nvm install --lts
nvm use v18.13.0
ln -s /home/jetson/.nvm/versions/node/v18.13.0/bin/node /home/jetson/.nvm/versions/node/v18.13.0/bin/nodejs
ln -s /home/jetson/.nvm/versions/node/v16.19.0/bin/node /home/jetson/.nvm/versions/node/v16.19.0/bin/nodejs
# X11 support	 
sudo apt install -y -q 'libxkb*'
sudo apt install -y -q '^libxcb.*'
sudo apt install -y -q libxcb1 libxcb1-dev libx11-xcb1 libx11-xcb-dev libx11-dev libx11-xcb-dev libxext-dev libxi-dev libxdamage-dev libxshmfence-dev libxshmfence1 libxcursor-dev libxtst-dev libxrandr-dev libfontconfig1-dev libfreetype6-dev libxfixes-dev libxrender-dev libdrm-dev libatspi2.0-dev libxss-dev libcap-dev libdirectfb-dev libxkbcommon-x11-dev libaudio-dev libxcomposite-dev 
# Wayland support
sudo apt install -y -q libwayland-dev libwayland-egl1-mesa libwayland-server0 libgles2-mesa-dev libxkbcommon-dev
# Pulseaudio support	
sudo apt install -y -q pulseaudio libpulse-dev
# Support for various databases (PostgreSQL, MariaDB/MySQL)
sudo apt install -y -q libpq-dev libmariadbclient-dev libsqlite3-dev
# Printing support using CUPS
sudo apt install -y -q libcups2-dev
# SCTP
sudo apt install -y -q libsctp-dev
# QT Tools
sudo apt install -y -q clang libclang-dev llvm
# CMake 2.25.1 (aarch64)
tar -xvf cmake-3.25.1-linux-aarch64.tar.gz cmake-3.25.1-linux-aarch64/
echo export PATH=/home/jetson/cmake-3.25.1-linux-aarch64/bin:$PATH >> ~/.profile
echo export PATH=/opt/Qt/6.4.2-armv8l/bin/:$PATH >> ~/.profile
source ~/.profile
# -------==========-------
# Build QT6
# https://www.tal.org/tutorials/building-qt-62-raspberry-pi-raspberry-pi-os
# -------==========-------
# Graphics driver options
export QT_FEATURE_opengles2=ON
export QT_FEATURE_opengles3=ON
export QT_FEATURE_kms=ON
export QT_FEATURE_vulkan=ON
export QT_QPA_DEFAULT_PLATFORM=eglfs
export BUILD_WITH_PCH=OFF

https://download.qt.io/official_releases/qt/
wget https://github.com/Kitware/CMake/releases/download/v3.25.1/cmake-3.25.1-linux-aarch64.tar.gz

tar -xvf qt-everywhere-src-6.4.2.tar.xz
mkdir ~/qteverywherebuild && cd ~/qteverywherebuild
cat > tc.cmake << "EOF"
# For armv6
# set(CMAKE_CROSSCOMPILING FALSE)
# set(CMAKE_SYSTEM_NAME Linux)
# set(CMAKE_SYSTEM_PROCESSOR armv6)
# set(TARGET armv6-linux-eabi)
# For armv7	
# set(CMAKE_CROSSCOMPILING FALSE)
# set(CMAKE_SYSTEM_NAME Linux)
# set(CMAKE_SYSTEM_PROCESSOR armv7)
# set(TARGET armv7-linux-eabi)
# For armv8	
# set(CMAKE_CROSSCOMPILING FALSE)
# set(CMAKE_SYSTEM_NAME Linux)
# set(CMAKE_SYSTEM_PROCESSOR armv8)
# set(TARGET armv8-linux-eabi)
# For aarch64
# TBA
EOF

# Clean Files
cmake --build . --target clean

# armv8 Linux
cmake -G Ninja -DCMAKE_INSTALL_PREFIX=/opt/Qt/6.4.2-armv8l -DQT_FEATURE_opengles2=ON -DQT_FEATURE_opengles3=ON -DCMAKE_TOOLCHAIN_FILE=tc.cmake -DQT_AVOID_CMAKE_ARCHIVING_API=ON ../qt-everywhere-src-6.4.2
# x86_64 Linux
../qt-everywhere-src-6.4.2/configure 
-prefix /opt/Qt/6.4.2-x86_64 \
-v

cmake --build . --parallel 4
cmake --install .

# Build Docs
cmake --build . --target docs
cmake --build . --target install_docs
# -------==========-------
# list installed modules 
/opt/Qt/6.4.2-armv8l/lib/cmake/Qt6
# Create a work directory
mkdir ~/qtmodules && cd ~/qtmodules
# Clone the repository
git clone https://github.com/qt/qtwebengine
git checkout 6.4.2
git submodule init
git submodule update
cd qtwebengine
OR 
cd ~/qteverywherebuild/qtwebengine
# Create a directory to build the module cleanly
mkdir build && cd build
# Use the qt-configure-module tool 
qt-configure-module ..
# Build it here
cmake --build . --parallel 2
# Install the module in the correct location 
cmake --install . --verbose
# -------==========-------
# Build QT5
# https://www.tal.org/tutorials/building-qt-512-lts-raspberry-pi-raspberry-pi-os
# -------==========-------
screen
tar -xvf qt-everywhere-src-5.15.8
mkdir ~/qteverywherebuild && cd ~/qteverywherebuild
# Configure first compiles qmake, then it`ll use it 
# if anything goes wrong in configure, do it again!
# sudo rm -rf ~/qteverywherebuild/*
../qt-everywhere-src-5.15.8/configure \
-opensource -confirm-license -release \
-reduce-exports \
-force-pkg-config \
-nomake examples -no-compile-examples  -nomake tests \
-no-feature-geoservices_mapboxgl \
-no-pch \
-no-gtk \
-make libs -make tools \
-qt-pcre \
-ssl \
-evdev \
-system-freetype \
-fontconfig \
-glib \
-prefix /opt/Qt/5.15.8-armv8l \
-opengl es2 -eglfs \
-v \
-qpa eglfs
-skip qtactiveqt -skip qtmacextras -skip qtwayland -skip qtwebengine \

make -j3
make install

echo export PATH=/opt/Qt/5.15.8-armv8l/bin/:$PATH >> ~/.profile
source ~/.profile
