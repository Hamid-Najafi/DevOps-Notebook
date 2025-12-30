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

# ! Show errdisable recovery
show errdisable recovery
conf t
interface giX/X/X
shutdown
no shutdown
end

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

# -------==========-------
# Monitoring
# -------==========-------


# -------==========-------
# NetFlow/sFlow
# -------==========-------


# -------==========-------
# SNMP
# -------==========-------
conf t
snmp-server group C1TechGroup v3 priv read C1TechRO write C1TechRW
snmp-server user C1TechUser C1TechGroup v3 auth sha AuthPass priv aes 128 PrivPass
snmp-server host 172.25.10.11 informs version 3 C1TechUser
end
write memory
# C1TechRO → community string (خواندن فقط)
# 172.25.10.11 → IP سرور Graylog یا سرور SNMP Collector
# snmp-server enable traps → فعال کردن ارسال Trap

# -------==========-------
# SYSLOG
# -------==========-------
conf t
logging host 172.25.10.11 transport udp port 5140
logging trap informational
logging source-interface vlan1
end
test logging
