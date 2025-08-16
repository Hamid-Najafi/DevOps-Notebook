# -------==========-------
# Useful Commands
# -------==========-------
# ! Show Switch Status
show switch
show switch detail
show switch stack-ports status

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

# ! Recover port from err
conf t
interface TE1/1/1
shutdown
no shutdown

# CDP (Cisco Discovery Protocol):
show cdp neighbors
show cdp neighbors detail

# LLDP (Link Layer Discovery Protocol):
conf t
lldp run
exit
wr
show lldp neighbors
show lldp neighbors detail

# -------==========-------
# Unsupported SFP
# -------==========-------
# ! Allow the use of non-Cisco or unsupported transceivers (e.g., SFP modules)
configure terminal
service unsupported-transceiver
do wr
