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

# -------==========-------
# VMware NSX
# -------==========-------
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