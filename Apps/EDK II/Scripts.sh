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
# Install Necessary Apps & Packages
sudo dnf group install  "C Development Tools and Libraries" 
sudo dnf group install -y "X Software Development"
sudo dnf install -y xorg-x11-server-Xorg xorg-x11-xauth xclock
sudo dnf group install -y --with-optional virtualization
sudo dnf group install -y qemu
sudo dnf install -y openssl-devel
# Windows Resource Compiler for Linux & Code Coverage Tools
sudo dnf install -y mingw64-gcc lcov
sudo dnf install -y python3-pip nuget libuuid-devel htop bmon nano zip unzip
pip install --upgrade pip setuptools wheel lcov_cobertura pycobertura
# Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install lts/fermium
nvm use lts/fermium
# Install NPM Packages
npm install -g cspell@5.20.0 markdownlint-cli@0.31.1
# -------==========-------
# Project MU
# -------==========-------
# Create Git Repo & Workspace Root
mkdir ProjectMU
cd ProjectMU
git init
# -------==========-------
Targets: DEBUG,RELEASE,NO-TARGET,NOOPT
Archs: IA32,X64,ARM,AARCH64 
stuart_ci_setup Clones MU_BASECORE
# -------==========-------
# MU_BASECORE
# This is the core section of TianoCore. Contains the guts of UEFI, forked from TianoCore, as well as the BaseTools needed to build. You will need this to continue.
git submodule add https://github.com/Microsoft/mu_basecore.git MU_BASECORE
cd MU_BASECORE
pip install --upgrade -r pip-requirements.txt
# TARGET_MDEMODULE: MdeModulePkg
stuart_setup -c .pytool/CISettings.py -p MdeModulePkg -t DEBUG -a X64 TOOL_CHAIN_TAG=GCC5
stuart_update -c .pytool/CISettings.py -p MdeModulePkg -t DEBUG -a X64 TOOL_CHAIN_TAG=GCC5
stuart_ci_build -c .pytool/CISettings.py -p MdeModulePkg -t DEBUG -a X64 TOOL_CHAIN_TAG=GCC5 CODE_COVERAGE=TRUE CC_HTML=TRUE
# TARGET_MDE_CPU: MdePkg,UefiCpuPkg
# TARGET_NETWORK: NetworkPkg 
# TARGET_OTHER: PcAtChipsetPkg,ShellPkg,StandaloneMmPkg,BaseTools
# TARGET_TEST_POLICY: UnitTestFrameworkPkg,PolicyServicePkg 
# TARGET_CRYPTO: CryptoPkg 
# -------==========-------
# MU_PLUS
# Additional, optional libraries and tools we've added to make MU great!
git submodule add https://github.com/Microsoft/mu_plus.git Common/MU
cd /home/fedora/ProjectMU/Common/MU
pip install --upgrade -r pip-requirements.txt
# TARGET_MFCI_XML: XmlSupportPkg,MfciPkg
# TARGET_GRAPHICS: MsGraphicsPkg 
# TARGET_CORE: MsCorePkg 
# TARGET_TEST_PCBDS_LOG_WHEA_HID: UefiTestingPkg,PcBdsPkg,AdvLoggerPkg,MsWheaPkg,HidPkg
# -------==========-------
# MU_TIANO_PLUS
# Additional, optional libraries and tools forked from TianoCore.
git submodule add https://github.com/Microsoft/mu_tiano_plus.git Common/TIANO
cd /home/fedora/ProjectMU/Common/TIANO
pip install --upgrade -r pip-requirements.txt
# TARGET_OTHER: EmbeddedPkg,PrmPkg,SourceLevelDebugPkg
# TARGET_FMP_FAT: FmpDevicePkg,FatPkg
# TARGET_SECURITY: SecurityPkg
# -------==========-------
# MU_OEM_SAMPLE
# This module is a sample implementation of a FrontPage and several BDS support libraries. This module is intended to be forked and customized.
git submodule add https://github.com/Microsoft/mu_oem_sample.git Common/MU_OEM_SAMPLE
cd /home/fedora/ProjectMU/Common/MU_OEM_SAMPLE
pip install --upgrade -r pip-requirements.txt
# TARGET_OEM: OemPkg
stuart_ci_setup -c .pytool/CISettings.py -p OemPkg -t DEBUG -a X64 TOOL_CHAIN_TAG=GCC5
stuart_setup -c .pytool/CISettings.py -p OemPkg -t DEBUG -a X64 TOOL_CHAIN_TAG=GCC5
stuart_update -c .pytool/CISettings.py -p OemPkg -t DEBUG -a X64 TOOL_CHAIN_TAG=GCC5
stuart_ci_build -c .pytool/CISettings.py -p OemPkg -t DEBUG -a X64 TOOL_CHAIN_TAG=GCC5
# -------==========-------
# MU_SILICON_ARM_TIANO
# Silicon code from TianoCore has been broken out into individual submodules. This is the ARM specific submodule.
git submodule add https://github.com/Microsoft/mu_silicon_arm_tiano.git Silicon/ARM/TIANO
cd /home/fedora/ProjectMU/Silicon/ARM/TIANO
pip install --upgrade -r pip-requirements.txt
# TARGET_ARMPKG: ArmPkg 
# TARGET_ARMPLATFORMPKG: ArmPlatformPkg 
# TARGET_PLATFORMS: ArmVirtPkg 
# -------==========-------
# MU_SILICON_INTEL_TIANO
# Silicon code from TianoCore has been broken out into individual submodules. This is the Intel specific submodule.
git submodule add https://github.com/Microsoft/mu_silicon_intel_tiano.git Silicon/INTEL/TIANO
cd /home/fedora/ProjectMU/Silicon/INTEL/TIANO
pip install --upgrade -r pip-requirements.txt
# TARGET_INTEL_SILICON: IntelSiliconPkg 
# TARGET_INTEL_FSP2: IntelFsp2Pkg,IntelFsp2WrapperPkg
# -------==========-------
# MU_COMMON_INTEL_MIN_PLATFORM
# Project Mu Minimum Platform
git submodule add https://github.com/microsoft/mu_common_intel_min_platform.git PlatformGroup/INTEL_MIN_PLATFORM
cd /home/fedora/ProjectMU/PlatformGroup/INTEL_MIN_PLATFORM
pip install --upgrade -r pip-requirements.txt
# TARGET_MinPlatform: MinPlatformPkg
stuart_ci_setup -c .pytool/CISettings.py -p MinPlatformPkg --force-git -t DEBUG,RELEASE,NO-TARGET,NOOPT -a IA32,X64,ARM,AARCH64 TOOL_CHAIN_TAG=GCC5
stuart_setup -c .pytool/CISettings.py -p MinPlatformPkg -t DEBUG,RELEASE,NO-TARGET,NOOPT -a IA32,X64,ARM,AARCH64 TOOL_CHAIN_TAG=GCC5
stuart_update -c .pytool/CISettings.py -p MinPlatformPkg -t DEBUG,RELEASE,NO-TARGET,NOOPT -a IA32,X64,ARM,AARCH64 TOOL_CHAIN_TAG=GCC5
stuart_ci_build -c .pytool/CISettings.py -p MinPlatformPkg -t DEBUG,RELEASE,NO-TARGET,NOOPT -a IA32,X64,ARM,AARCH64 TOOL_CHAIN_TAG=GCC5 CODE_COVERAGE=TRUE CC_HTML=TRUE
# -------==========-------
# MU_TIANO_PLATFORMS
# Project Mu Virtual Platform Firmware
git submodule add https://github.com/microsoft/mu_tiano_platforms.git PlatformGroup/INTEL_TIANO
cd /home/fedora/ProjectMU/PlatformGroup/INTEL_TIANO
pip install --upgrade -r pip-requirements.txt
# Build Non-Platform Package(s) NO-TARGET: QemuQ35Pkg,QemuSbsaPkg
stuart_setup -c .pytool/CISettings.py -p QemuQ35Pkg,QemuSbsaPkg -t NO-TARGET -a IA32,X64,AARCH64 TOOL_CHAIN_TAG=GCC5
stuart_update -c .pytool/CISettings.py -p QemuQ35Pkg,QemuSbsaPkg -t NO-TARGET -a IA32,X64,AARCH64 TOOL_CHAIN_TAG=GCC5
stuart_ci_build -c .pytool/CISettings.py -p QemuQ35Pkg,QemuSbsaPkg -t NO-TARGET -a IA32,X64,AARCH64 TOOL_CHAIN_TAG=GCC5
# QemuQ35Pkg GCC QemuQ35_DEBUG
stuart_setup -c Platforms/QemuQ35Pkg/PlatformBuild.py TOOL_CHAIN_TAG=GCC5 -t DEBUG -a IA32,X64
stuart_update -c Platforms/QemuQ35Pkg/PlatformBuild.py TOOL_CHAIN_TAG=GCC5 -t DEBUG -a IA32,X64
stuart_build -c Platforms/QemuQ35Pkg/PlatformBuild.py TOOL_CHAIN_TAG=GCC5 TARGET=DEBUG -a IA32,X64
# QemuSbsaPkg GCC QemuSbsa_DEBUG
stuart_setup -c Platforms/QemuSbsaPkg/PlatformBuild.py TOOL_CHAIN_TAG=GCC5 -t DEBUG -a IA32,X64
stuart_update -c Platforms/QemuSbsaPkg/PlatformBuild.py TOOL_CHAIN_TAG=GCC5 -t DEBUG -a IA32,X64
stuart_build -c Platforms/QemuSbsaPkg/PlatformBuild.py TOOL_CHAIN_TAG=GCC5 TARGET=DEBUG -a IA32,X64
# Run Emulator
stuart_build -c Platforms/QemuQ35Pkg/PlatformBuild.py TOOL_CHAIN_TAG=GCC5 --FlashOnly
stuart_build -c Platforms/QemuQ35Pkg/PlatformBuild.py TOOL_CHAIN_TAG=GCC5 --FlashRom

stuart_build -c Platforms/QemuSbsaPkg/PlatformBuild.py TOOL_CHAIN_TAG=GCC5 --FlashOnly
stuart_build -c Platforms/QemuSbsaPkg/PlatformBuild.py TOOL_CHAIN_TAG=GCC5 --FlashRom
# OR 
qemu-system-x86_64 \
/home/fedora/qemu-7.2.0/build/qemu-system-x86_64 \
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
# mu_feature_config
https://github.com/microsoft/mu_feature_config.git
# mu_feature_dfci
https://github.com/microsoft/mu_feature_dfci.git
# mu_feature_ipmi
https://github.com/microsoft/mu_feature_ipmi.git
# mu_feature_mm_supv
https://github.com/microsoft/mu_feature_mm_supv.git
# mu_feature_uefi_variable
https://github.com/microsoft/mu_feature_uefi_variable.git
# -------==========-------
# Run to make sure all the submodules are set up.
git submodule update --init
# -------==========-------
# EDK2
# -------==========-------
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
