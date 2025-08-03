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
# sudo dnf group install -y "C Development Tools and Libraries" 
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
# Q35 on QEMU (Fedora 36)
# -------==========-------
# Disk Space: 5GB
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
build \
-p QemuQ35Pkg/QemuQ35Pkg.dsc \
-b DEBUG \
-t GCC5 \
-a IA32 \
-a X64 \
-y /home/fedora/mu_tiano_platforms/Build/QemuQ35Pkg/DEBUG_GCC5/BUILD_REPORT.TXT \
-Y PCD \
-Y DEPEX \
-Y FLASH \
-Y BUILD_FLAGS \
-Y LIBRARY \
-Y FIXED_ADDRESS \
-Y HASH \
-D BUILDID_STRING=Unknown \
-D QEMU_CORE_NUM=2 \
-D MEMORY_PROTECTION=TRUE \
-D SHIP_MODE=FALSE \
-D POLICY_BIN_PATH=/home/fedora/mu_tiano_platforms/Build/QemuQ35Pkg/DEBUG_GCC5/Policy/secure_policy.bin

# Run Emulator
export DISPLAY=localhost:11.0
# FlashOnly : Run Last Build, FlashRom: Build & Run
python Platforms/QemuQ35Pkg/PlatformBuild.py TOOL_CHAIN_TAG=GCC5 --FlashOnly
python Platforms/QemuQ35Pkg/PlatformBuild.py TOOL_CHAIN_TAG=GCC5 --FlashRom
python Platforms/QemuSbsaPkg/PlatformBuild.py TOOL_CHAIN_TAG=GCC5 --FlashOnly
python Platforms/QemuSbsaPkg/PlatformBuild.py TOOL_CHAIN_TAG=GCC5 --FlashRom
# QemuQ35Pkg
stuart_build -c Platforms/QemuQ35Pkg/PlatformBuild.py TOOL_CHAIN_TAG=GCC5 --FlashOnly 
stuart_build -c Platforms/QemuQ35Pkg/PlatformBuild.py TOOL_CHAIN_TAG=GCC5 --FlashRom
# QemuSbsaPkg
stuart_build -c Platforms/QemuSbsaPkg/PlatformBuild.py TOOL_CHAIN_TAG=GCC5 --FlashOnly
stuart_build -c Platforms/QemuSbsaPkg/PlatformBuild.py TOOL_CHAIN_TAG=GCC5 --FlashRom
# OR 
export VirtualDrive=/home/fedora/mu_tiano_platforms/Build/QemuQ35Pkg/DEBUG_GCC5/VirtualDrive
export QEMUQ35_CODE=/home/fedora/mu_tiano_platforms/Build/QemuQ35Pkg/DEBUG_GCC5/FV/QEMUQ35_CODE.fd
export QEMUQ35_VARS=/home/fedora/mu_tiano_platforms/Build/QemuQ35Pkg/DEBUG_GCC5/FV/QEMUQ35_VARS.fd
qemu-system-x86_64 \
 -debugcon stdio \
 -global isa-debugcon.iobase=0x402 \
 -global ICH9-LPC.disable_s3=1 \
 -net none \
 -drive file=fat:rw:$VirtualDrive,format=raw,media=disk \
 -machine q35,smm=on \
 -m 2048 \
 -cpu qemu64,+rdrand,umip,+smep \
 -smp 2 \
 -global driver=cfi.pflash01,property=secure,value=on \
 -drive if=pflash,format=raw,unit=0,file=$QEMUQ35_CODE,readonly=on \
 -drive if=pflash,format=raw,unit=1,file=$QEMUQ35_VARS \
 -device qemu-xhci,id=usb \
 -device usb-mouse,id=input0,bus=usb.0,port=1 \
 -smbios type=0,vendor=Palindrome,uefi=on \
 -smbios type=1,manufacturer=Palindrome,product=MuQemuQ35,serial=42-42-42-42 \
 -vga cirrus

export VirtualDrive=/home/fedora/mu_tiano_platforms/Build/QemuSbsaPkg/DEBUG_GCC5/VirtualDrive
export SECURE_FLASH0=/home/fedora/mu_tiano_platforms/Build/QemuSbsaPkg/DEBUG_GCC5/FV/SECURE_FLASH0.fd
export QEMU_EFI=/home/fedora/mu_tiano_platforms/Build/QemuSbsaPkg/DEBUG_GCC5/FV/QEMU_EFI.fd
 qemu-system-aarch64 \
 -net none \
 -drive file=fat:rw:$VirtualDrive,format=raw,media=disk \
 -m 2048 \
 -machine sbsa-ref \
 -cpu max \
 -smp 4 \
 -global driver=cfi.pflash01,property=secure,value=on \
 -drive if=pflash,format=raw,unit=0,file=$SECURE_FLASH0 \
 -drive if=pflash,format=raw,unit=1,file=$QEMU_EFI,readonly=on \
 -device qemu-xhci,id=usb \
 -device usb-mouse,id=input0,bus=usb.0,port=1 
 -device usb-kbd,id=input1,bus=usb.0,port=2 
 -smbios type=0,vendor=Palindrome,uefi=on 
 -smbios type=1,manufacturer=Palindrome,product=MuQemuQ35,serial=42-42-42-42 
 -serial stdio

# -------==========-------
Cant run using fedora-qemu
https://github.com/microsoft/mu_tiano_platforms/issues/240
INFO - MM IPL closed SMRAM window index 0
INFO - MM IPL closed SMRAM window index 1
INFO - MM IPL locked SMRAM window index 0
INFO - MM IPL locked SMRAM window index 1
INFO - SecurityLock::LockType: HARDWARE_LOCK, Module: E6D1F588-F107-41DE-9832-CEA334B33C1F, Function: MmIplPeiEntry, Output: Lock MMRAM
INFO - SMM IPL locked SMRAM window
# -------==========-------


# -------==========-------
# Q35 on QEMU (Windows 10)
# -------==========-------
# Install Chocolatey
# Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
# choco install python --pre 
# choco install git

0.1- Download latest TrafficMonitor
https://github.com/zhongyang219/TrafficMonitor/releases

0.2- Microsoft Visual C++ Redistributable (Updated March 2023)
https://cdna.p30download.ir/p30dl-software/Microsoft.Visual.C.Plus.Plus.Redistributable.Package.v0.67.0_p30download.com.exe

0.3- Disable Windows Security (Speed-UP)

0.4- Install Cygwin
http://cygwin.com/setup-x86_64.exe
https://x.cygwin.com/docs/ug/setup.html
https://gist.github.com/roxlu/5038729
Cygwin Packages: xorg-server, xinit, xorg-docs, xlaunch, openssh
Cygwin:  ssh-host-config
Windows: Create a new account with administrator rights
Windows: Open Firewall Port
Cygwin:  /bin/mkpasswd.exe -l -u [new_username] >> /etc/passwd

0.5- Create Script in C:/FlashRomMUQemu.sh Which Contains:
cd /cygdrive/c/mu_tiano_platforms
export DISPLAY=localhost:10.0
python Platforms/QemuQ35Pkg/PlatformBuild.py TARGET=DEBUG -a IA32,X64 TOOL_CHAIN_TAG=VS2022 TEST_REGEX=FrontPage.efi RUN_TESTS=TRUE --FlashOnly

# OR
# 0.4- Windows Native OpenSSH Server
# Open Settings, then go to Apps > Apps & Features.
# Go to Optional Features.
# In the list, select OpenSSH Client or OpenSSH Server.
# Select Install.
# Start, type services.msc
# In the details pane, double-click OpenSSH SSH Server.
# On the General tab, from the Startup type drop-down menu, select Automatic
# To start the service, select Start

1- Download latest Python
https://www.python.org/downloads

2- Download latest Git For Windows
https://git-scm.com/download/win

3.1- Download latest Qemu For Windows
https://qemu.weilnetz.de/w64/
3.2- Add Qemu to Path Variables
setx /M path "%path%;C:\Program Files\qemu"

4.1- Download latest version of VS build Tools
https://aka.ms/vs/17/release/vs_buildtools.exe (2022)
https://aka.ms/vs/16/release/vs_buildtools.exe (2019)
4.2- Install from cmd line with required features (this set will change over time).
.\vs_buildtools.exe --wait --norestart --nocache --installPath C:\BuildTools --add Microsoft.VisualStudio.Component.VC.CoreBuildTools --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows11SDK.22000 --add Microsoft.VisualStudio.Component.VC.Tools.ARM --add Microsoft.VisualStudio.Component.VC.Tools.ARM64
.\vs_buildtools.exe --wait --norestart --nocache --installPath C:\BuildTools2019 --add Microsoft.VisualStudio.Component.VC.CoreBuildTools --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows10SDK.19041 --add Microsoft.VisualStudio.Component.VC.Tools.ARM --add Microsoft.VisualStudio.Component.VC.Tools.ARM64

5.1- Download the WDK installer
https://go.microsoft.com/fwlink/?linkid=2085767
5.2- Install from cmd line with required features (this set will change over time).
.\wdksetup.exe /features OptionId.WindowsDriverKitComplete

6- https://github.com/tianocore/edk2-pytool-extensions/blob/master/docs/user/features/using_linux.md

7- Clone Repo
# Common Error (Compiler #1076 from NMAKE : fatal name too long)
git clone https://github.com/microsoft/mu_tiano_platforms.git C:\mu_tiano_platforms
cd C:\mu_tiano_platforms
python -m pip install --upgrade pip setuptools wheel
pip install --upgrade -r pip-requirements.txt

8- Build & Run
stuart_setup -c Platforms/QemuQ35Pkg/PlatformBuild.py -t DEBUG -a IA32,X64 TOOL_CHAIN_TAG=VS2022 
stuart_update -c Platforms/QemuQ35Pkg/PlatformBuild.py -t DEBUG -a IA32,X64 TOOL_CHAIN_TAG=VS2022  
stuart_build -c Platforms/QemuQ35Pkg/PlatformBuild.py -t DEBUG -a IA32,X64 TOOL_CHAIN_TAG=VS2022
# Test Build and Shutdown (Using *TestApp.efi files)
stuart_build -c Platforms/QemuQ35Pkg/PlatformBuild.py TOOL_CHAIN_TAG=VS2022 TARGET=DEBUG -a IA32,X64  SHUTDOWN_AFTER_RUN=TRUE QEMU_HEADLESS=TRUE EMPTY_DRIVE=TRUE TEST_REGEX=*TestApp.efi RUN_TESTS=TRUE --FlashOnly
# On HostOS using X11 Forwading
C:\cygwin64\bin\bash.exe /cygdrive/c/FlashRomMUQemu.sh