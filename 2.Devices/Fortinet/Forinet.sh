# -------==========-------
# Update
# -------==========-------

# Upgrade Path Tools
https://docs.fortinet.com/upgrade-tool/fortigate
##* DO NOT UPDATE TO 7.4 WITH OFFLINE LICENCE *##

# FortiOS Release Notes
https://docs.fortinet.com/document/fortigate/7.4.0/fortios-release-notes/760203/introduction-and-supported-models

# -------==========-------
# fortinet-offline-update
# -------==========-------
https://www.ressis.net/fortinet-offline-update/

execute restore av tftp Antivirus.pkg 192.168.1.128
execute restore av tftp Mobile-Malware.pkg 192.168.1.128
execute restore av tftp AVAI.pkg 192.168.1.128 
execute restore ips tftp Industrial-DB.pkg 192.168.1.128
execute restore  other-objects tftp Internet-Service.pkg 192.168.1.128

execute restore application tftp Application-Control.pkg 192.168.1.128

execute restore av tftp Application-Control.pkg 192.168.1.128
execute restore av tftp Internet-Service.pkg 192.168.1.128
execute restore av tftp IPS.pkg 192.168.1.128
