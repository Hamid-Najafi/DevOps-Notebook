# -------==========-------
# Initial Setup
# -------==========-------
! Enter Privileged EXEC
enable

! Enter global configuration mode
configure terminal

! Set hostname to Access-3750-02
hostname Access-3750-04
! hostname Core-3850-01

! Configure VLAN 1 with IP address
interface vlan 1
 ip address 172.25.20.30 255.255.255.0
 no shutdown
exit

! Set default gateway
! ip default-gateway 172.25.20.1

! Enable SSH
ip domain-name espad-pharmed.local
crypto key generate rsa general-keys modulus 2048
ip ssh version 2
line vty 0 4
 transport input ssh
 login local
exit
username admin privilege 15 secret AdminPass

! Encrypt passwords
service password-encryption

! Allow non-Cisco transceivers
service unsupported-transceiver

! Enable HTTP and HTTPS with restricted access
! access-list 10 permit 172.25.20.0 0.0.0.255
! ip http authentication local
! ip http server
! ip http secure-server
! ip http access-class 10

! Exit configuration mode
exit

! Save configuration to NVRAM
write memory