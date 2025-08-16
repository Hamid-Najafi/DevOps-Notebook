# -------==========-------
# NetBootXYZ Docker Compose
# Your favorite operating systems in one place. A network-based bootable operating system installer based on iPXE.
# -------==========-------
# https://github.com/netbootxyz/netboot.xyz
# https://netboot.xyz/docs/docker

# Make NetBootXYZ Directory
sudo mkdir -p /mnt/data/netbootxyz/config
sudo mkdir -p /mnt/data/netbootxyz/assets

# Set Permissions
sudo chown -R root:root /mnt/data/netbootxyz/
sudo chmod 777 -R /mnt/data/netbootxyz/

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/netbootxyz/config \
      --opt o=bind netbootxyz-config

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/netbootxyz/assets \
      --opt o=bind netbootxyz-assets

# Clone NetBootXYZ Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/1.OperatingSystems/1.Ubuntu/netboot.xyz ~/docker/netbootxyz
cd ~/docker/netbootxyz

# Check and Edit .env file
nano .env

# Create Network and Run
# docker network create netbootxyz-network
docker compose up -d

# -------==========-------
# Config DHCP Server
# -------==========-------
https://github.com/netbootxyz/netboot.xyz?tab=readme-ov-file#bootloader-downloads

netboot.xyz.kpxe	Legacy DHCP boot image file, uses built-in iPXE NIC drivers
netboot.xyz-undionly.kpxe	Legacy DHCP boot image file, use if you have NIC issues
netboot.xyz.efi	UEFI boot image file, uses built-in UEFI NIC drivers
netboot.xyz-snp.efi	UEFI w/ Simple Network Protocol, attempts to boot all net devices
netboot.xyz-snponly.efi	UEFI w/ Simple Network Protocol, only boots from device chained from
netboot.xyz-arm64.efi	DHCP EFI boot image file, uses built-in iPXE NIC drivers
netboot.xyz-arm64-snp.efi	UEFI w/ Simple Network Protocol, attempts to boot all net devices
netboot.xyz-arm64-snponly.efi	UEFI w/ Simple Network Protocol, only boots from device chained from
netboot.xyz-rpi4-snp.efi	UEFI for Raspberry Pi 4, attempts to boot all net devices

# -------==========-------
# Use Self-Hosed Asset
# -------==========-------
open https://netboot.c1tech.group/
goto Menus
Edit boot.cfg
set live_endpoint https://asset.c1tech.group/
Save Config