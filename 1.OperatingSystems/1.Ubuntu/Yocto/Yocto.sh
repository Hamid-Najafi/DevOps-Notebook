# -------==========-------
# YOCTO
# -------==========-------
# https://docs.yoctoproject.org/brief-yoctoprojectqs/index.html
# Preparation
# Install the necessary Linux Operating system packages.
sudo apt-get update
sudo apt-get -y -q install gawk wget git git-core diffstat unzip texinfo gcc gcc-multilib
sudo apt-get -y -q install build-essential chrpath socat cpio tree screen
sudo apt-get -y -q install python3 python3-pip python3-pexpect python3-subunit python3-git python3-jinja2 
sudo apt-get -y -q install libsdl1.2-dev liblz4-tool libegl1-mesa mesa-common-dev 
sudo apt-get -y -q install xz-utils debianutils iputils-ping zstd file locales libacl1 xterm

# Clone the poky repository
git clone git://git.yoctoproject.org/poky.git
cd poky/

# Check all available tags inside Poky repository
# These shows all the version of Yocto Project, available through Poky.
git tag 
# Select YOCTO Release
# https://wiki.yoctoproject.org/wiki/Releases
# Version 3.1
git checkout dunfell
# OR Version 4.0
git checkout kirkstone 
# OR Version 5.0
git checkout scarthgap
# Check  version of Poky
more ./meta-poky/conf/distro/poky.conf

# -------==========-------
# Download the Necessary Meta-Layers
# -------==========-------

git clone https://git.yoctoproject.org/meta-raspberrypi ~/poky
git clone https://github.com/agherzan/meta-raspberrypi.git ~/poky
cd ~/poky/meta-raspberrypi
git checkout dunfell
git checkout kirkstone

git clone https://git.openembedded.org/meta-openembedded ~/poky
cd ~/poky/meta-openembedded
git checkout dunfell
git checkout kirkstone
git checkout scarthgap

git clone https://github.com/openembedded/openembedded-core.git ~/poky
cd ~/poky/openembedded-core
git checkout 2022-04.13-kirkstone
git checkout scarthgap
git checkout dunfell
git checkout nanbield

git clone https://code.qt.io/yocto/meta-qt5.git ~/poky
git clone https://code.qt.io/yocto/meta-qt6.git ~/poky
git clone https://github.com/meta-qt5/meta-qt5.git ~/poky

# Clone C1Tech Custom Layer
git clone https://github.com/Hamid-Najafi/meta-c1tech.git ~/poky

# -------==========-------
# Source the poky building environment
# All of the configuration, intermediate, and target image files will be placed in the ‘build-armv7l’ directory.
# You must source this script each time you want to work again on the same project.
source oe-init-build-env
source oe-init-build-env build-rpi4/
source oe-init-build-env build-armv7l/

# Edit the conf/bblayers.conf file
nano ./conf/bblayers.conf

# Edit the conf/local.conf file
nano ./conf/local.conf

MACHINE ??= "raspberrypi4-64"
# The file specified above is a configuration file that is provided in the meta-raspberrypi layer. 
# That file is located in the meta-raspberrypi/conf/machine directory, 
# along with the configuration files for all the other possible Raspberry Pi boards available.

# Build Image
# To actully perform a build, you need to actually run BitBake and tell it which root filesystem image to create.
# For example here are some common examples of images, as Yocto offers more than like these:
# core-image-minimal This is a small console-based system which is useful for tests and as a basis for other custom images. Minimal images allow devices to boot, useful for BSP development . BSP stands for Board Support Package
# core-image-full-cmdline Console only image with full support of target device hardware
# core-image-x11 This is a basic image with support for graphics through a X11 server and the xTerminal terminal app.
# core-image-sato This is a complete graphical system based on Sato which is a mobile graphical environment built on X11 and GNOME. This image includes several apps like: a Terminal , a text editor and a file manager
# core-image-sato-sdk This is a core-image-sato added with complete standalone Software Development Kit (SDK)
# BitBake executes a number of defined tasks such as :
#     downloads all source files,
#     unpacks them,
#     patches them
#     configures them,
#     compiles and
#     installs these files.
screen -S bitbake
bitbake core-image-sato
bitbake core-image-minimal
bitbake c1tech-image
bitbake -c cleanall core-image-sato 
bitbake -c cleanall core-image-sato 
bitbake -k meta-toolchain-qt6

# Verify the structure of the build directory after the image is completed
tree -L 2 build-armv7l/tmp/deploy/

# Run/verify first Linux image
runqemu qemuarm nographic slirp
runqemu qemux86-64 nographic slirp

# Yocto defaults to “root” without any password
uname -a
poweroff

# -------==========-------
# Using the Toaster web interface
# -------==========-------
sudo apt install -y python3-pip
cd /opt/yocto/poky
pip3 install --user -r ./bitbake/toaster-requirements.txt
source oe-init-build-env
source toaster start

git clone --branch latest https://github.com/jsamr/bootiso.git
cd bootiso
sudo make install
sudo apt install -y jq wimlib
bootiso ./build-armv7l/tmp/deploy/images/beaglebone-yocto/core-image-minimal-beaglebone-yocto-20231111131527.rootfs.wic of=/dev/sdd bs=1M