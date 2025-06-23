! Enter global configuration mode
configure terminal

! Set configuration register to 0x2102 to load startup-config on boot
config-register 0x2102

! Exit configuration mode
exit

! Save the change to NVRAM
write memory