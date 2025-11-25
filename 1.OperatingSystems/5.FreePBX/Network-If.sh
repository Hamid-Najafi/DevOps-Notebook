
# root@freepbx:~# cat /etc/network/interfaces
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# Loopback
auto lo
iface lo inet loopback


# PortGroup-VoIP 172.21.171.0/25
auto ens224
iface ens224 inet static
    address 172.21.171.1
    netmask 255.255.255.128

# PortGroup-VM 172.25.10.0/24
auto ens192
iface ens192 inet static
    address 172.25.10.30
    netmask 255.255.255.0
    gateway 172.25.10.1
    dns-nameservers 172.25.10.15
    post-up ip route add 46.100.142.67/32 via 172.21.171.126 dev ens224
    pre-down ip route del 46.100.142.67/32 via 172.21.171.126 dev ens224