# -------==========-------
# Useful Commands
# -------==========-------
# ! Display the current running configuration of the switch
show running-config
show startup-config

show version | include Configuration register
# ! Show summary of interface status and IP addresses
show ip interface brief

# ! Display RSA public key for SSH
show crypto key mypubkey rsa

# ! Show SSH server status and active sessions
show ssh

# ! List all VLANs, their status, and assigned ports
show vlan brief

# ! Display hardware inventory (model, serial number, modules)
show inventory

# ! Show status of all interfaces (connected, VLAN, speed, duplex)
show interfaces status

# ! Show detailed status and stats for interfaces
show interfaces TE1/1/1

# ! Show transceiver details for interfaces
show interfaces TE1/1/1 transceiver

# -------==========-------
# Unsupported SFP
# -------==========-------
# ! Enter global configuration mode to modify switch settings
configure terminal

# ! Allow the use of non-Cisco or unsupported transceivers (e.g., SFP modules)
service unsupported-transceiver

# ! Exit global configuration mode
exit

# ! Save the running configuration to NVRAM to persist after reboot
write memory