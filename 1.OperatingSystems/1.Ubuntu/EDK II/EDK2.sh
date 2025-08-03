#!/bin/bash -e

# Copyleft (c) 2022.
# -------==========-------
# Systemm Setup
# -------==========-------
# Same as Project-MU
# -------==========-------
# EDK2
# -------==========-------
# Clone Repo
git clone https://github.com/tianocore/edk2.git /home/fedora/EDK2
cd /home/fedora/EDK2
git submodule update --init --recursive
pip install -r pip-requirements.txt --upgrade
# Build OvmfPkg
stuart_setup -c OvmfPkg/PlatformCI/PlatformBuild.py  -t DEBUG -a X64 TOOL_CHAIN_TAG=GCC5
stuart_update -c OvmfPkg/PlatformCI/PlatformBuild.py -t DEBUG -a X64 TOOL_CHAIN_TAG=GCC5
python BaseTools/Edk2ToolsBuild.py -t GCC5
stuart_build -c  OvmfPkg/PlatformCI/PlatformBuild.py -t DEBUG -a X64 TOOL_CHAIN_TAG=GCC5
# Run
stuart_build -c OvmfPkg/PlatformCI/PlatformBuild.py TOOL_CHAIN_TAG=GCC5 -a X64 --FlashOnly
# OR
export FIRMWARE=/home/fedora/EDK2/Build/OvmfX64/DEBUG_GCC5/FV/OVMF.fd
export VIRTDRIVE=/home/fedora/EDK2/Build/OvmfX64/DEBUG_GCC5/VirtualDrive
qemu-system-x86_64 -debugcon stdio -global isa-debugcon.iobase=0x402 -net none -drive file=fat:rw:$VIRTDRIVE,format=raw,media=disk -pflash $FIRMWARE -fw_cfg name=opt/org.tianocore/X-Cpuhp-Bugcheck-Override,string=yes
/home/fedora/qemu-7.2.0/build/qemu-system-x86_64 -debugcon stdio -global isa-debugcon.iobase=0x402 -net none -drive file=fat:rw:$VIRTDRIVE,format=raw,media=disk -pflash $FIRMWARE -fw_cfg name=opt/org.tianocore/X-Cpuhp-Bugcheck-Override,string=yes