# ===============================
# Cisco Switch Config
# ===============================

enable
configure terminal

! Set hostname
 ! hostname Core-3850-24P-02
 hostname Core-3750-48P-01
 hostname Access-3560-24P-01

! VLAN 1 - Management IP
interface vlan 1
 ip address 172.25.20.14 255.255.255.0
 no shutdown
exit

! Default gateway
ip default-gateway 172.25.10.1

! Disable DNS lookup
no ip domain-lookup

! Set domain name for SSH
ip domain-name c1tech.local

! Generate SSH keys
crypto key generate rsa general-keys modulus 2048
ip ssh version 2

! Create local admin
username admin privilege 15 secret Admin!@C1Tech#$

! Enable secret
enable secret My$uperS3cret

! Configure VTY for SSH only
line vty 0 4
 transport input ssh
 login local
exit

! Configure console with timeout and password
line console 0
 password Console!123
 login
 exec-timeout 5 0
exit

! Encrypt all passwords
service password-encryption

! Allow unsupported SFPs
service unsupported-transceiver

! Enable login security
login block-for 60 attempts 3 within 60

! MOTD banner
banner motd ^C
!!! Unauthorized access is prohibited.
!!! Support: C1Tech Group
!!! Email: devops@c1tech.group
^C

! Enable logging
logging buffered 4096
logging trap warnings

! Clock and NTP
clock timezone IRDT 3 30
! clock summer-time IRDT recurring last Sun Mar 2:00 last Sun Sep 2:00
ntp server 172.25.10.10

! Enable DHCP snooping for VLAN 1
! ip dhcp snooping
! ip dhcp snooping vlan 1

! Trust UPLINK ports (fiber ports) - change if needed
! interface TenGigabitEthernet0/1
!  ip dhcp snooping trust
! exit
! interface TenGigabitEthernet0/2
!  ip dhcp snooping trust
! exit

! Access Ports (GigabitEthernet) - Protect against rogue switches
! interface range gigabitEthernet1/0/1 - 48
!  spanning-tree portfast
!  spanning-tree bpduguard enable
!  switchport port-security maximum 2
!  switchport port-security violation restrict
!  switchport port-security
! exit

! Disable unused ports if known
! interface range gigabitEthernet1/0/45 - 48
! shutdown
! exit

! Enable CDP/LLDP
 cdp run
 lldp run

! Enable HTTP and HTTPS server for web GUI access
 ! ip http server
 ! ip http secure-server

! Optional: define local authentication method for HTTP access
 ! ip http authentication local

! Exit and save
exit
wr
reload