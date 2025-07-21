# -------==========-------
# MSA2060
# -------==========-------
HPE MSA 2060 Storage
https://support.hpe.com/connect/s/product?language=en_US&kmpmoid=1012748869

# -------==========-------
# Firmware
# -------==========-------
Online Flash Component for Windows and Linux - HPE MSA 1060/2060/2062 Storage System
https://support.hpe.com/connect/s/softwaredetails?language=en_US&collectionId=MTX-3b214b7d8e3e46ae&tab=releaseNotes

# -------==========-------
# Add Storage to Windows
# -------==========-------
# PowerShell 
Update-HostStorageCache
Get-Disk | Where-Object IsOffline -Eq $true
Get-StorageSetting
Set-StorageSetting -NewDiskPolicy OnlineAll
