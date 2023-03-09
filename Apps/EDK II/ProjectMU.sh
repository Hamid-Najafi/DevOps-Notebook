#!/bin/bash -e

# Copyleft (c) 2022.
# -------==========-------
# OS: Ferdora 36
# Systemm Setup
# -------==========-------
# System Config
sudo timedatectl set-timezone Asia/Tehran 
sudo hostnamectl set-hostname EDK2-TU
echo -e "127.0.0.1 EDK2-TU" | sudo tee -a /etc/hosts
# https://www.linuxfedora.ir/tutorials/other/things_to_do_after_installing_fedora
sudo echo "fastestmirror=true" >> /etc/dnf/dnf.conf
sudo echo "max_parallel_downloads=20" >> /etc/dnf/dnf.conf
sudo echo "deltarpm=1" >> /etc/dnf/dnf.conf
sudo echo "ip_resolve=4" >> /etc/dnf/dnf.conf

# Install Necessary Apps & Packages
sudo dnf update -y
sudo dnf group install -y "C Development Tools and Libraries" 
sudo dnf install -y xorg-x11-server-Xorg xorg-x11-xauth xclock
# sudo dnf group install --with-optional virtualization
sudo dnf group install -y qemu 
sudo dnf install -y mono-devel nuget
sudo dnf install -y mingw64-gcc lcov
sudo dnf install -y python3-pip ninja-build openssl-devel libuuid-devel pixman-devel.x86_64 wget htop bmon nano zip unzip avahi
pip install --upgrade pip setuptools wheel lcov_cobertura pycobertura

# rpm --import "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF"
# su -c 'curl https://download.mono-project.com/repo/centos8-stable.repo | tee /etc/yum.repos.d/mono-centos8-stable.repo'
# dnf update
# dnf install mono-devel
# sudo curl -o /usr/local/bin/nuget.exe https://dist.nuget.org/win-x86-commandline/latest/nuget.exe
# alias nuget="mono /usr/local/bin/nuget.exe"

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
# Staurt Manual:
# https://github.com/tianocore/edk2-pytool-extensions/blob/master/docs/user/index.md
# stuart_setup: Initialize & Update Submodules - only when submodules updated
# stuart_update: Initialize & Update Dependencies - only as needed when ext_deps change
# stuart_build: Compile Firmware
# stuart_setup -c .pytool/CISettings.py -h: see additional options
# -------==========-------
# MU_BASECORE
# This is the core section of TianoCore. Contains the guts of UEFI, forked from TianoCore, as well as the BaseTools needed to build. You will need this to continue.
git submodule add https://github.com/Microsoft/mu_basecore.git MU_BASECORE
cd /home/fedora/ProjectMU/MU_BASECORE
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
git submodule add https://github.com/Microsoft/mu_tiano_plus.git Common/MU_TIANO
cd /home/fedora/ProjectMU/Common/MU_TIANO
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
git submodule add https://github.com/Microsoft/mu_silicon_arm_tiano.git Silicon/ARM/MU_TIANO
git submodule add https://github.com/ARM-software/arm-trusted-firmware.git Silicon/ARM/TFA # Commit: 35f4c7295bafeb32c8bcbdfb6a3f2e74a57e732b
cd /home/fedora/ProjectMU/Silicon/ARM/MU_TIANO
pip install --upgrade -r pip-requirements.txt
# TARGET_ARMPKG: ArmPkg 
# TARGET_ARMPLATFORMPKG: ArmPlatformPkg 
# TARGET_PLATFORMS: ArmVirtPkg 
# -------==========-------
# MU_SILICON_INTEL_TIANO
# Silicon code from TianoCore has been broken out into individual submodules. This is the Intel specific submodule.
git submodule add https://github.com/Microsoft/mu_silicon_intel_tiano.git Silicon/INTEL/MU_TIANO
cd /home/fedora/ProjectMU/Silicon/INTEL/MU_TIANO
pip install --upgrade -r pip-requirements.txt
# TARGET_INTEL_SILICON: IntelSiliconPkg 
stuart_ci_setup -c .pytool/CISettings.py -p IntelSiliconPkg -t DEBUG -a X64 TOOL_CHAIN_TAG=GCC5
stuart_setup -c .pytool/CISettings.py -p IntelSiliconPkg -t DEBUG -a X64 TOOL_CHAIN_TAG=GCC5
stuart_update -c .pytool/CISettings.py -p IntelSiliconPkg -t DEBUG -a X64 TOOL_CHAIN_TAG=GCC5
stuart_ci_build -c .pytool/CISettings.py -p IntelSiliconPkg -t DEBUG -a X64 TOOL_CHAIN_TAG=GCC5
# TARGET_INTEL_FSP2: IntelFsp2Pkg,IntelFsp2WrapperPkg
# -------==========-------
# MU_COMMON_INTEL_MIN_PLATFORM
# Project Mu Minimum Platform
git submodule add https://github.com/microsoft/mu_common_intel_min_platform.git PlatformGroup/INTEL/MU_MIN
cd /home/fedora/ProjectMU/PlatformGroup/INTEL/MU_MIN
pip install --upgrade -r pip-requirements.txt
# TARGET_MinPlatform: MinPlatformPkg
stuart_ci_setup -c .pytool/CISettings.py -p MinPlatformPkg --force-git -t DEBUG,RELEASE,NO-TARGET,NOOPT -a IA32,X64,ARM,AARCH64 TOOL_CHAIN_TAG=GCC5
stuart_setup -c .pytool/CISettings.py -p MinPlatformPkg -t DEBUG,RELEASE,NO-TARGET,NOOPT -a IA32,X64,ARM,AARCH64 TOOL_CHAIN_TAG=GCC5
stuart_update -c .pytool/CISettings.py -p MinPlatformPkg -t DEBUG,RELEASE,NO-TARGET,NOOPT -a IA32,X64,ARM,AARCH64 TOOL_CHAIN_TAG=GCC5
stuart_ci_build -c .pytool/CISettings.py -p MinPlatformPkg -t DEBUG,RELEASE,NO-TARGET,NOOPT -a IA32,X64,ARM,AARCH64 TOOL_CHAIN_TAG=GCC5 CODE_COVERAGE=TRUE CC_HTML=TRUE
# -------==========-------
# mu_feature_config
git submodule add https://github.com/microsoft/mu_feature_config.git Features/CONFIG
# mu_feature_dfci
git submodule add https://github.com/microsoft/mu_feature_dfci.git Features/DFCI
# mu_feature_ipmi
git submodule add https://github.com/microsoft/mu_feature_ipmi.git Features/IPMI
# mu_feature_mm_supv
git submodule add https://github.com/microsoft/mu_feature_mm_supv.git Features/MM_SUPV
# mu_feature_uefi_variable
git submodule add https://github.com/microsoft/mu_feature_uefi_variable.git Features/UEFI_VARIABLE
# -------==========-------
# Run to make sure all the submodules are set up.
git submodule update --init --recursive

# -------==========-------
# Example on QEMU
# -------==========-------
# MU_TIANO_PLATFORMS
# Mu Tiano Platform is a public repository of Project Mu based firmware that targets the open-source QEMU processor emulator.
cd ~
git clone https://github.com/microsoft/mu_tiano_platforms.git
cd mu_tiano_platforms
pip install --upgrade -r pip-requirements.txt

# Flags
# QEMU_HEADLESS=FALSE 
# SHUTDOWN_AFTER_RUN=TRUE
# MEMORY_PROTECTION=FALSE
# --codeql
# QemuQ35Pkg GCC QemuQ35_DEBUG
stuart_setup -c Platforms/QemuQ35Pkg/PlatformBuild.py -t DEBUG -a IA32,X64 TOOL_CHAIN_TAG=GCC5
stuart_update -c Platforms/QemuQ35Pkg/PlatformBuild.py -t DEBUG -a IA32,X64 TOOL_CHAIN_TAG=GCC5 
stuart_build -c Platforms/QemuQ35Pkg/PlatformBuild.py -t DEBUG -a IA32,X64 TOOL_CHAIN_TAG=GCC5
# QemuSbsaPkg GCC QemuSbsa_DEBUG
stuart_setup -c Platforms/QemuSbsaPkg/PlatformBuild.py -t DEBUG -a AARCH64 TOOL_CHAIN_TAG=GCC5
stuart_update -c Platforms/QemuSbsaPkg/PlatformBuild.py -t DEBUG -a AARCH64 TOOL_CHAIN_TAG=GCC5
stuart_build -c Platforms/QemuSbsaPkg/PlatformBuild.py -t DEBUG -a AARCH64 TOOL_CHAIN_TAG=GCC5
# Build Non-Platform Package(s) NO-TARGET: QemuQ35Pkg,QemuSbsaPkg
# ONLY FOR CI
# stuart_setup -c .pytool/CISettings.py -p QemuQ35Pkg,QemuSbsaPkg -t NO-TARGET -a IA32,X64,AARCH64 TOOL_CHAIN_TAG=GCC5
# stuart_update -c .pytool/CISettings.py -p QemuQ35Pkg,QemuSbsaPkg -t NO-TARGET -a IA32,X64,AARCH64 TOOL_CHAIN_TAG=GCC5
# stuart_ci_build -c .pytool/CISettings.py -p QemuQ35Pkg,QemuSbsaPkg -t NO-TARGET -a IA32,X64,AARCH64 TOOL_CHAIN_TAG=GCC5

# Run Emulator
export DISPLAY=localhost:11.0
# FlashOnly : Run Last Build, FlashRom: Build & Run
python Platforms/QemuQ35Pkg/PlatformBuild.py TOOL_CHAIN_TAG=GCC5  --FlashRom
python Platforms/QemuSbsaPkg/PlatformBuild.py TOOL_CHAIN_TAG=GCC5  --FlashRom
# QemuQ35Pkg
stuart_build -c Platforms/QemuQ35Pkg/PlatformBuild.py TOOL_CHAIN_TAG=GCC5 --FlashOnly 
stuart_build -c Platforms/QemuQ35Pkg/PlatformBuild.py TOOL_CHAIN_TAG=GCC5 --FlashRom
# QemuSbsaPkg
stuart_build -c Platforms/QemuSbsaPkg/PlatformBuild.py TOOL_CHAIN_TAG=GCC5 --FlashOnly
stuart_build -c Platforms/QemuSbsaPkg/PlatformBuild.py TOOL_CHAIN_TAG=GCC5 --FlashRom
# OR 
qemu-system-x86_64 \
/home/fedora/qemu-7.2.0/build/qemu-system-x86_64 \
-debugcon stdio \
-global isa-debugcon.iobase=0x402 \
-global ICH9-LPC.disable_s3=1 \
-net none \
-drive file=fat:rw:/home/fedora/ProjectMU/PlatformGroup/INTEL/MU_QEMU/Build/QemuQ35Pkg/DEBUG_GCC5/VirtualDrive/,format=raw,media=disk \
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

/home/fedora/ProjectMU/PlatformGroup/INTEL/MU_QEMU/Build/QemuQ35Pkg/DEBUG_GCC5/VirtualDrive/
