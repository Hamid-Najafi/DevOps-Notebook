# -------==========-------
# Brocade SAN switch 
# -------==========-------

# -------==========-------
# 🔍 Basic Useful Commands
# -------==========-------
# Connect to the switch via SSH
ssh admin@<IP-switch>
# Show status of all ports and general switch info
switchshow
porterrshow
portshow 0
nodefind 51:40:2e:c0:17:31:0a:78

nsshow
# Enable the switch (bring it online)
switchenable
# Show all alliases configuration
alishow
# Show all zones and their members
zoneshow
# Show active zone configuration
cfgshow
# Show current switch configuration
configshow
# Show switch uptime, firmware, and system info
version
# Check port errors and counters
porterrshow

defzone --show
Default Zone Access Mode
        committed - All Access
        transaction - No Transaction

# -------==========-------
# 🧹 Factory Reset Steps
# -------==========-------
# Disable the switch before making changes
switchdisable
# Disable current zoning configuration
cfgdisable
# Clear all zone configurations
cfgClear
# Reset switch settings to factory defaults (not necessary)
configDefault
# Reboot the switch
reboot

# -------==========-------
# 📦 Zoning Configuration Commands
# -------==========-------
# 1. Fabrics works in  Open Fabric mode with no zone configuration
defzone --show
defzone --noaccess
# 2. Create an alias for a WWPNs
alicreate "MyHost-HBA1", "51:40:2e:c0:17:31:0a:78"
# 3. Create a zone with 2 members (host and storage port)
zonecreate "zone_Host1_to_MSA1", "MyHost-HBA1;MSA_Port1"
# 3.1. Add more members to an existing zone
zoneadd "zone_Host1_to_MSA1", "MSA_Port2"
# 4. Create a zone config (aka zone set)
cfgcreate "cfg_Host1", "zone_Host1_to_MSA1"
# 4.1 Add more zones to an existing config
cfgadd "cfg_Host1", "zone_OtherHost"
# 5. Save the configuration to NVRAM (required after changes!)
cfgsave
# 6. Activate a zone configuration
cfgenable "cfg_Host1"
# -- Disable a zone configuration
cfgdisable

# 7. Save configuration to a file (via GUI or FTP/SCP via CLI)
# Usually done from web GUI: Administration > Configuration File > Download
scp admin@<IP-switch>:/etc/fabric.cfg ./backup-fabric.cfg
scp admin@<IP-switch>:/fabos/config/* ./full-backup/

# .Done
