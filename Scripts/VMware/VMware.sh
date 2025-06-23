# -------==========-------
# VMware ESXi
# -------==========-------
# Update ESXI
1. Download Depot-OffileBundle ZIP
2. Import to Datastore
3. SSH to ESXCLI
localcli system maintenanceMode get
esxcli software sources profile list -d  /vmfs/volumes/DataStore-01/ISO/VMware-ESXi-8.0.3-24022510-HPE-803.0.0.11.7.0.23-Jun2024-depot.zip 
esxcli software profile update -d /vmfs/volumes/DataStore-01/ISO/VMware-ESXi-8.0.3-24022510-HPE-803.0.0.11.7.0.23-Jun2024-depot.zip -p HPE-Custom-AddOn_803.0.0.11.7.0-23 --no-hardware-warning
# -------==========-------
# VMware NSX
# -------==========-------
adduser vmware
usermod -aG sudo vmware

sudo mkdir -p /mnt/backup/vmware-nsx
sudo chown -R vmware:vmware /mnt/backup/vmware-nsx
sudo chmod -R 770 /mnt/backup/vmware-nsx

# -------==========-------
# VMware QLogic Fibre Channel HBA
# QLE2692 Dual Port 16Gb Fibre Channel to PCIe Adapter
# -------==========-------
# Recommended Firmware (VMware vSphere 8.0 & MS-Winows)
CP066317   HPE Firmware Flash for QLogic Fibre Channel Host Bus Adapters for VMware vSphere 8.0   2025.05.01.2-8.0.0.20613240

# Recommended Driver Kit (MS-Windows)

# Optional Utility and Software
mrvlfcesxcliplugin   Marvell QLogic ESXCLI Extension for Fibre Channel Adapters   1.7.4-1OEM.800.1.0.20613240 
qlogic-adapter-provider        QLogic Adapter provider for ESXi7.0 Server    1.7.21-10404389
viplugin-provider        QLogic VIPlugin CIM Provider ESXi 7.0 Server        1.1.13-10404389    

# To update firmware from VMware ESXi operating system on target server:
# Enable Tech Support Mode on the ESXi host.

# Login as root. (You must be root in order to apply the ROM update.)
# Place the Smart Component (CPxxxxxx.zip) in a temporary directory.
cp /vmfs/volumes/DataStore-Secondary/Drivers/CP066317.zip /var/log/vmware

# From the same directory, unzip the Smart Component.
cd /var/log/vmware
unzip CPxxxxxx.zip
# The smart component includes CPxxxxx_VMw.zip which consists of VIB which needs to be installed to perform firmware installation
# Ensure that the file CPxxxxxx_VMw.zip is executable. Execute the command:
chmod +x CPxxxxxx_VMw.zip
# To perform the standalone installation, execute the command:
esxcli software vib install -d /<path_of_CPxxxxxx_VMw.zip>CPxxxxxx_VMw.zip
# Once the installation completes, change directory to /opt/Smart_Component/<CPxxxxxx>. Execute the comand:
cd /opt/Smart_Component/<CPxxxxxx>
# To perform standalone installation of the firmware,Execute the command:
./Execute_Component
# Follow the directions given by the Smart Component
# Logout
# Disable Tech Support Mode on the ESXi host
# Reboot your system, if required, for the firmware update to take effect



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

# -------==========-------
# VMware Tanzu Kubernetes Grid
# -------==========-------
https://customerconnect.vmware.com/downloads/details?downloadGroup=TKG-241&productId=1400&rPId=113920

# -------==========-------
# VMware
# -------==========-------
vSphere 8 Enterprise Plus:
HG00K-03H8K-48929-8K1NP-3LUJ4

vSphere 8 Enterprise:
4F40H-4ML1K-M89U0-0C2N4-1AKL4

vCenter Server 8 Standard:
4F282-0MLD2-M8869-T89G0-CF240
0F41K-0MJ4H-M88U1-0C3N0-0A214

vSAN 8 Enterprise Plus:
MG292-08L9K-48078-KJ372-27K20

Tanzu Standard:
MC682-4JK00-M8908-0LAN4-068J0

Site Recovery Manager:
HU01H-4205K-081V9-693NK-3G0Q0