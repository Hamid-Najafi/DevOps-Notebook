#!/bin/bash -e

# Copyleft (c) 2022.
# -------==========-------
# OS: Ferdora 36
# Hostname: 
# Username: 
# Password: 
# CPU: 
# Memory: 
# -------==========-------
# https://www.linuxfedora.ir/tutorials/other/things_to_do_after_installing_fedora
sudo echo "fastestmirror=true" >> /etc/dnf/dnf.conf
sudo echo "max_parallel_downloads=20" >> /etc/dnf/dnf.conf
sudo echo "deltarpm=1" >> /etc/dnf/dnf.conf
sudo echo "ip_resolve=4" >> /etc/dnf/dnf.conf
# -------==========-------
# Systemm Setup
# -------==========-------
# Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install lts/fermium
nvm use lts/fermium
npm install -g cspell@5.20.0  markdownlint-cli
# Usefull apps
sudo dnf group install -y "X Software Development"
sudo dnf install -y xorg-x11-server-Xorg xorg-x11-xauth xclock
sudo dnf group install -y --with-optional virtualization
sudo dnf group install -y qemu
sudo dnf --assumeyes install openssl-devel
# -------==========-------
# Project MU
# -------==========-------
# Create Git Repo & Workspace Root
mkdir ProjectMU
cd ProjectMU
git init
# -------==========-------
# MU_BASECORE
# This is the core section of TianoCore. Contains the guts of UEFI, forked from TianoCore, as well as the BaseTools needed to build. You will need this to continue.
git submodule add https://github.com/Microsoft/mu_basecore.git MU_BASECORE
cd MU_BASECORE
python -m pip install --upgrade pip setuptools wheel
pip install --upgrade -r pip-requirements.txt
stuart_setup -c .pytool/CISettings.py -p MdeModulePkg -t DEBUG -a X64 TOOL_CHAIN_TAG=GCC5
stuart_update -c .pytool/CISettings.py -p MdeModulePkg -t DEBUG -a X64 TOOL_CHAIN_TAG=GCC5
stuart_ci_build -c .pytool/CISettings.py -p MdeModulePkg -t DEBUG -a X64 TOOL_CHAIN_TAG=GCC5 CODE_COVERAGE=TRUE CC_HTML=TRUE
# -------==========-------
# MU_PLUS
# Additional, optional libraries and tools we've added to make MU great!
git submodule add https://github.com/Microsoft/mu_plus.git Common/MU

# -------==========-------
# MU_TIANO_PLUS
# Additional, optional libraries and tools forked from TianoCore.
git submodule add https://github.com/Microsoft/mu_tiano_plus.git Common/TIANO

# -------==========-------
# MU_OEM_SAMPLE
# This module is a sample implementation of a FrontPage and several BDS support libraries. This module is intended to be forked and customized.
git submodule add https://github.com/Microsoft/mu_oem_sample.git Common/MU_OEM_SAMPLE
cd /home/fedora/ProjectMU/Common/MU_OEM_SAMPLE
python -m pip install --upgrade pip setuptools wheel
pip install --upgrade -r pip-requirements.txt
stuart_ci_setup -c .pytool/CISettings.py -p OemPkg -t DEBUG -a X64 TOOL_CHAIN_TAG=GCC5
stuart_setup -c .pytool/CISettings.py -p OemPkg -t DEBUG -a X64 TOOL_CHAIN_TAG=GCC5
stuart_update -c .pytool/CISettings.py -p OemPkg -t DEBUG -a X64 TOOL_CHAIN_TAG=GCC5
stuart_ci_build -c .pytool/CISettings.py -p OemPkg -t DEBUG -a X64 TOOL_CHAIN_TAG=GCC5
# -------==========-------
# MU_SILICON_ARM_TIANO
# Silicon code from TianoCore has been broken out into individual submodules. This is the ARM specific submodule.
git submodule add https://github.com/Microsoft/mu_silicon_arm_tiano.git Silicon/ARM/TIANO

# -------==========-------
# MU_SILICON_INTEL_TIANO
# Silicon code from TianoCore has been broken out into individual submodules. This is the Intel specific submodule.
git submodule add https://github.com/Microsoft/mu_silicon_intel_tiano.git Silicon/INTEL/TIANO

# -------==========-------
# Project Mu Virtual Platform Firmware
git submodule add https://github.com/microsoft/mu_tiano_platforms.git PlatformGroup/INTEL_TIANO
cd /home/fedora/ProjectMU/PlatformGroup/INTEL_TIANO
python -m pip install --upgrade pip setuptools wheel
pip install --upgrade -r pip-requirements.txt

stuart_setup -c Platforms/QemuQ35Pkg/PlatformBuild.py TOOL_CHAIN_TAG=GCC5 -t DEBUG -a IA32,X64
stuart_update -c Platforms/QemuQ35Pkg/PlatformBuild.py TOOL_CHAIN_TAG=GCC5 -t DEBUG -a IA32,X64
stuart_build -c Platforms/QemuQ35Pkg/PlatformBuild.py TOOL_CHAIN_TAG=GCC5 TARGET=DEBUG -a IA32,X64

stuart_setup -c .pytool/CISettings.py -p QemuQ35Pkg,QemuSbsaPkg -t NO-TARGET -a IA32,X64,AARCH64 TOOL_CHAIN_TAG=GCC5
stuart_update -c .pytool/CISettings.py -p QemuQ35Pkg,QemuSbsaPkg -t NO-TARGET -a IA32,X64,AARCH64 TOOL_CHAIN_TAG=GCC5
stuart_ci_build -c .pytool/CISettings.py -p QemuQ35Pkg,QemuSbsaPkg -t NO-TARGET -a IA32,X64,AARCH64 TOOL_CHAIN_TAG=GCC5

# Run Emulator
stuart_build -c Platforms/QemuQ35Pkg/PlatformBuild.py TOOL_CHAIN_TAG=GCC5 --FlashOnly
stuart_build -c Platforms/QemuQ35Pkg/PlatformBuild.py TOOL_CHAIN_TAG=GCC5 --FlashRom
# OR 
qemu-system-x86_64 \
-debugcon stdio \
-global isa-debugcon.iobase=0x402 \
-global ICH9-LPC.disable_s3=1 \
-net none \
-drive file=fat:rw:/home/fedora/ProjectMU/PlatformGroup/INTEL_TIANO/Build/QemuQ35Pkg/DEBUG_GCC5/VirtualDrive,format=raw,media=disk \
-machine q35,smm=on \
-m 2048 \
-cpu qemu64,+rdrand,umip,+smep \
-smp 2 \
-global driver=cfi.pflash01,property=secure,value=on \
-drive if=pflash,format=raw,unit=0,file=/home/fedora/ProjectMU/PlatformGroup/INTEL_TIANO/Build/QemuQ35Pkg/DEBUG_GCC5/FV/QEMUQ35_CODE.fd,readonly=on \
-drive if=pflash,format=raw,unit=1,file=/home/fedora/ProjectMU/PlatformGroup/INTEL_TIANO/Build/QemuQ35Pkg/DEBUG_GCC5/FV/QEMUQ35_VARS.fd \
-device qemu-xhci,id=usb \
-device usb-mouse,id=input0,bus=usb.0,port=1 \
-smbios type=0,vendor=Palindrome,uefi=on \
-smbios type=1,manufacturer=Palindrome,product=MuQemuQ35,serial=42-42-42-42 \
-vga cirrus
# OR
python Platforms/QemuQ35Pkg/PlatformBuild.py TOOL_CHAIN_TAG=GCC5  --FlashOnly
# -------==========-------
# Run to make sure all the submodules are set up.
git submodule update --init
# -------==========-------
# EDK2
# -------==========-------
sudo dnf groupinstall  "C Development Tools and Libraries" 
sudo dnf install -y python3-pip nuget libuuid-devel htop bmon nano

# Clone Repo
mkdir ~/src
cd ~/src
git clone https://github.com/tianocore/edk2.git
cd edk2
git submodule update --init --recursive
pip install -r pip-requirements.txt --upgrade

# Build OvmfPkg
stuart_setup -c  OvmfPkg/PlatformCI/PlatformBuild.py  -t DEBUG -a X64 TOOL_CHAIN_TAG=GCC5
stuart_update -c  OvmfPkg/PlatformCI/PlatformBuild.py -t DEBUG -a X64 TOOL_CHAIN_TAG=GCC5
python BaseTools/Edk2ToolsBuild.py -t GCC5
stuart_build -c  OvmfPkg/PlatformCI/PlatformBuild.py -t DEBUG -a X64 TOOL_CHAIN_TAG=GCC5
# Run
stuart_build -c OvmfPkg/PlatformCI/PlatformBuild.py TOOL_CHAIN_TAG=GCC5 -a X64 --FlashOnly
# OR
mkdir -p /home/fedora/src/edk2/Build/OvmfX64/DEBUG_GCC5/VirtualDrive
export FIRMWARE=/home/fedora/src/edk2/Build/OvmfX64/DEBUG_GCC5/FV/OVMF.fd
export VIRTDRIVE=/home/fedora/src/edk2/Build/OvmfX64/DEBUG_GCC5/VirtualDrive
qemu-system-x86_64 -debugcon stdio -global isa-debugcon.iobase=0x402 -net none -drive file=fat:rw:$VIRTDRIVE,format=raw,media=disk -pflash $FIRMWARE -fw_cfg name=opt/org.tianocore/X-Cpuhp-Bugcheck-Override,string=yes
# -------==========-------
# QEMU
# -------==========-------
sudo dnf install -y ninja-build
cd /home/fedora/
wget https://download.qemu.org/qemu-7.2.0.tar.xz
tar xvJf qemu-7.2.0.tar.xz
cd qemu-7.2.0
./configure
make -j4
/home/fedora/qemu-7.2.0/build/qemu-system-x86_64 --version
# -------==========-------
# TEEEMP
# -------==========-------
# Install Essential Packages
sudo apt update
sudo apt-get install virt-manager libvirt-daemon ovmf
sudo apt install -y libpixman-1-dev libcairo2-dev libpango1.0-dev libjpeg8-dev libgif-dev ninja-build
sudo apt-get install xorg openbox xauth xdg-utils
sudo apt install -y qemu qemu-system qemu-system-gui qemu-system-x86 qemu-block-extra qemu-utils

wget https://releases.ubuntu.com/22.04.2/ubuntu-22.04.2-live-server-amd64.iso
qemu-img create ubuntu.img 10G
qemu-img create -f qcow2 ubuntu.qcow 10G
qemu-system-x86_64 -hda ubuntu.img -boot d -cdrom ubuntu-22.04.2-live-server-amd64.iso -m 640
qemu -hda ubuntu.img -m 640

/etc/ssh/sshd_config
X11Forwarding yes
X11DisplayOffset 10
X11UseLocalHost no
PrintMotd no

unzip memtest86-usb.zip

sudo qemu-system-x86_64 \
    -enable-kvm -m 2G \
    -bios /usr/share/edk2-ovmf/OVMF_CODE.fd \
    -drive file=memtest86-usb.img,format=raw
qemu-system-x86_64
