# -------==========-------
# Initial Setup
# -------==========-------
! Enter Privileged EXEC
enable

! Enter global configuration mode
configure terminal

! Set hostname
hostname Access-3750-48P-04
! hostname Core-3850-24P-01

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
username admin privilege 15 secret Admin!@Pass

! Encrypt passwords
service password-encryption

! Allow non-Cisco transceivers
service unsupported-transceiver

! Enable HTTP and HTTPS with restricted access
! access-list 10 permit 172.25.20.0 0.0.0.255
ip http authentication local
ip http server
ip http secure-server
! ip http access-class 10

! Exit configuration mode
exit

! Save configuration to NVRAM
write memory

# -------==========-------
# Update
# -------==========-------
show version
# show file systems
# Check for Free Space
show flash
# dir flash:
# delete /force /recursive flash:


# Enable TFTP Server: Tfptpd32
copy tftp flash
172.25.20.128
c3750e-universalk9-mz.152-4.E10.bin

dir flash:
#  530  -rwx    25549824   Jan 2 2006 00:42:06 +00:00  c3750e-universalk9-mz.152-4.E10.bin

show boot
conf terminal
boot system flash:/c3750e-universalk9-mz.152-4.E10.bin
do wr
exit
reload

# Wait to BOOT About 10 MIN
conf terminal
do wr
exit
show startup-config
reload