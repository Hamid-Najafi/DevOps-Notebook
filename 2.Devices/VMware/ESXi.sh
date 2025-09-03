# -------==========-------
# VMware ESXi
# -------==========-------

# Install ESXi
✅ Official HPE Recommendation:
Install ESXi on one of the following supported boot devices:

HPE SATA SSD (even a small 120GB drive)
HPE M.2 NVMe (using a supported PCIe adapter)
HPE RAID1 SSDs on a Smart Array controller
If you must install ESXi on an SD Card (not recommended):
Disable persistent logging
Manually set the scratch location to a persistent datastore


# Update ESXI
1. Download Depot-OffileBundle ZIP
2. Import to Datastore
3. SSH to ESXCLI
localcli system maintenanceMode get
esxcli software sources profile list -d  /vmfs/volumes/DataStore-01/ISO/VMware-ESXi-8.0.3-24022510-HPE-803.0.0.11.7.0.23-Jun2024-depot.zip 
esxcli software profile update -d /vmfs/volumes/DataStore-01/ISO/VMware-ESXi-8.0.3-24022510-HPE-803.0.0.11.7.0.23-Jun2024-depot.zip -p HPE-Custom-AddOn_803.0.0.11.7.0-23 --no-hardware-warning


# -------==========-------
# Firmware Installation Guide -- Use SPP Instead
# -------==========------
# To update firmware from VMware ESXi operating system on target server:
# Enable Tech Support Mode on the ESXi host.

# Login as root. (You must be root in order to apply the ROM update.)
# Place the Smart Component (CPxxxxxx.zip) in a temporary directory.
cp /vmfs/volumes/DataStore-Primary/Drivers/cp066710.zip /var/log/vmware
 
# From the same directory, unzip the Smart Component.
cd /var/log/vmware
unzip CPxxxxxx.zip
# The smart component includes CPxxxxx_VMw.zip which consists of VIB which needs to be installed to perform firmware installation
# Ensure that the file CPxxxxxx_VMw.zip is executable. Execute the command:
chmod +x CPxxxxxx_VMw.zip
# To perform the standalone installation, execute the command:
esxcli software vib install -d /<path_of_CPxxxxxx_VMw.zip>CPxxxxxx_VMw.zip


## For Some Packages
# Once the installation completes, change directory to /opt/Smart_Component/<CPxxxxxx>. Execute the comand:
cd /opt/Smart_Component/<CPxxxxxx>
# To perform standalone installation of the firmware,Execute the command:
./Execute_Component
# Follow the directions given by the Smart Component
# Logout
# Disable Tech Support Mode on the ESXi host
# Reboot your system, if required, for the firmware update to take effect

# -------==========-------
# VMware NSX
# -------==========-------
adduser vmware
usermod -aG sudo vmware

sudo mkdir -p /mnt/backup/vmware-nsx
sudo chown -R vmware:vmware /mnt/backup/vmware-nsx
sudo chmod -R 770 /mnt/backup/vmware-nsx

# -------==========-------
# vRealize Suite
# -------==========-------
This management suite is made up of several components, including vRealize Automation, vRealize Operations, vRealize Log Insight and vRealize Business for Cloud.

# -------==========-------
# vCenter Server Management
# -------==========-------
sudo mkdir -p /mnt/backup/vmware-vcsa
sudo chown -R vmware:vmware /mnt/backup/vmware-vcsa
sudo chmod -R 770 /mnt/backup/vmware-vcsa

sftp://172.25.10.8:22/mnt/backup/vmware-vcsa
