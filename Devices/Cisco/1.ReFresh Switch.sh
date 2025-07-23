# -------==========-------
# ReNumber to Swtich 1 (Standalone Mode)
# -------==========-------
en
show switch
conf t
switch *X renumber 1
no switch *X provision
no system ignore startupconfig switch all
config-register 0x102
exit
write memory

# -------==========-------
# Update IOS
# -------==========-------
enable
show version

write erase
erase startup-config
delete vlan.dat
# !!! Dont Save Configurtion in reload prompt !!!
! reload

dir flash:
delete /f /r flash:*

configure terminal
    interface vlan 1
        ip address 172.25.20.30 255.255.255.0
        no shutdown
        exit
    exit

# Enable TFTP Server: Tfptpd32
# https://cdn.technet24.ir/Downloads/Cisco/IOS/
copy tftp://172.25.20.128/c3560e-universalk9-mz.152-4.E10.bin flash:
# verify /md5 flash:c3560e-universalk9-mz.152-4.E10.bin
# 1e363a4f136c745fa9d069924320d85c

# copy tftp://172.25.20.128/c3750e-universalk9-mz.152-4.E10.bin flash:
# verify /md5 flash:c3750e-universalk9-mz.152-4.E10.bin
# 6f3b3ddec62c77747c214cc7be555ec4

# copy tftp://172.25.20.128/cat3k_caa-universalk9.16.12.13.SPA.bin flash:
# verify /md5 flash:cat3k_caa-universalk9.16.12.13.SPA.bin
# 107c3002fd7f96adfb3a5bafd2d5bd66

dir flash:

# -------==========-------
# Install Mode -- IOS XE
# request platform software package clean switch all
request platform software package install flash:cat3k_caa-universalk9.16.12.13.SPA.bin new
reload
show version | include Mode

# -------==========-------
# Bundle Mode -- IOS
show boot
conf terminal
no boot system
# boot system flash:c3560e-universalk9-mz.152-4.E10.bin
# boot system flash:c3750e-universalk9-mz.152-4.E10.bin
# boot system flash:cat3k_caa-universalk9.16.12.13.SPA.bin
do write memory
end
show boot
reload

# WAIT to BOOT About 10-15 Min
# enable
# write erase
conf terminal
do write memory
exit
show startup-config
show version | include Mode
reload