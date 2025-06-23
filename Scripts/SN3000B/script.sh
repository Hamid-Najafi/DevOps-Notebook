# -------==========-------
# Brocade SAN switch 
# -------==========-------

# 🔍 Basic Useful Commands
# Connect to the switch via SSH
ssh admin@<IP-switch>
# Show status of all ports and general switch info
switchshow
# Show all zones and their members
zoneshow
# Show active zone configuration
cfgshow
# Enable the switch (bring it online)
switchenable
# Show all defined aliases
aliasshow
# Show all defined zone configs
cfglist
# Show current switch configuration
configshow
# Show switch uptime, firmware, and system info
version
# Check port errors and counters
porterrshow

# 🧹 Factory Reset Steps
# Disable the switch before making changes
switchdisable
# Disable current zoning configuration
cfgdisable
# Clear all zone configurations
cfgClear
# Reset switch settings to factory defaults
configDefault
# Reboot the switch
reboot

# 📦 Zoning Configuration Commands
# Create an alias for a WWPN
alicreate "MyHost-HBA1", "51:40:2e:c0:17:31:0a:78"
# Create a zone with 2 members (host and storage port)
zonecreate "zone_Host1_to_MSA1", "MyHost-HBA1;MSA_Port1"
# Add more members to an existing zone
zoneadd "zone_Host1_to_MSA1", "MSA_Port2"
# Create a zone config (aka zone set)
cfgcreate "cfg_Host1", "zone_Host1_to_MSA1"
# Add more zones to an existing config
cfgadd "cfg_Host1", "zone_OtherHost"
# Save the configuration to NVRAM (required after changes!)
cfgsave
# Activate a zone configuration
cfgenable "cfg_Host1"
# Disable a zone configuration
cfgdisable

# Save configuration to a file (via GUI or FTP/SCP via CLI)
# Usually done from web GUI: Administration > Configuration File > Download
scp admin@<IP-switch>:/etc/fabric.cfg ./backup-fabric.cfg
scp admin@<IP-switch>:/fabos/config/* ./full-backup/

# -------==========-------
# SPAD-SN3600B
# -------==========-------
# Connect G10A, G10B HBA Port A & B to MSA Controller A1 & B1

# Step 1: Create Aliases for All WWPNs
alicreate "MSA_A1", "20:70:00:c0:ff:f6:84:cd" 
alicreate "MSA_A2", "21:70:00:c0:ff:f6:84:cd" 
alicreate "MSA_A3", "22:70:00:c0:ff:f6:84:cd" 
alicreate "MSA_A4", "23:70:00:c0:ff:f6:84:cd" 
alicreate "MSA_B1", "24:70:00:c0:ff:f6:84:cd" 
alicreate "MSA_B2", "25:70:00:c0:ff:f6:84:cd" 
alicreate "MSA_B3", "26:70:00:c0:ff:f6:84:cd" 
alicreate "MSA_B4", "27:70:00:c0:ff:f6:84:cd" 

alicreate "G10A-HBA1", "51:40:2e:c0:17:31:0a:78"
alicreate "G10A-HBA2", "51:40:2e:c0:17:31:0a:7a"
alicreate "G10B-HBA1", "51:40:2e:c0:17:29:d3:9c"
alicreate "G10B-HBA2", "51:40:2e:c0:17:29:d3:9e"
cfgshow

# Step 2: Create Zones (One HBA port <-> One Storage port)
zonecreate "zone_G10A_HBA1_MSA_A1", "G10A-HBA1;MSA_A1"
zonecreate "zone_G10A_HBA2_MSA_B1", "G10A-HBA2;MSA_B1"
zonecreate "zone_G10B_HBA1_MSA_A2", "G10B-HBA1;MSA_A2"
zonecreate "zone_G10B_HBA2_MSA_B2", "G10B-HBA2;MSA_B2"
cfgshow

cfgcreate "cfg_SAN_FULL", "zone_G10A_HBA1_MSA_A1;zone_G10A_HBA2_MSA_B1;zone_G10B_HBA1_MSA_A2;zone_G10B_HBA2_MSA_B2"
cfgsave
cfgenable "cfg_SAN_FULL"

# -------==========-------
# Add Storage to Windows
# -------==========-------
# PowerShell 
Update-HostStorageCache
Get-Disk | Where-Object IsOffline -Eq $true
Get-StorageSetting
Set-StorageSetting -NewDiskPolicy OnlineAll
