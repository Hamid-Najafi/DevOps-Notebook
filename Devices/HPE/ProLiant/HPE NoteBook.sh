# -------==========-------
# Service Pack for ProLiant (SPP) Bundle 
# -------==========-------
# Guide
# Smart Update Manager (SUM)
# https://itpfdoc.hitachi.co.jp/manuals/ha8000v/hard/Gen1x/SUM/30-BE5E207C-002.pdf
# iSmart Update Tools (iSUT)
# https://support.hpe.com/hpesc/public/docDisplay?docLocale=en_US&docId=a00112960en_us

Quick Firmware Update Guide for ESXi with HPE SUM and iSUT
1.Run HPE Smart Update Manager (SUM) on your management PC
2.Scan your iLO host and upload all available firmware and driver updates to the host.
3.Upload Service Pack for ProLiant (SPP) Bundle to iLO
4.Enable ESXi Shell or SSH and log in as root.
5.Ensure Integrated Smart Update Tools (iSUT) are installed on ESXi
# The Integrated Smart Update tool (iSUT) is by default not installed on a vanilla ESXi node.
# Only when using the HPE Customized ISO when installing vSphere ESXi onto the server, will SUT be present.
# https://vibsdepot.hpe.com/customimages/Content_of_HPE_ESXi_Release_Images.pdf
6.Run the firmware update and reboot command on ESXi
sut -deployreboot
or
sut -set mode=AutoDeployReboot
sut -start
7.After reboot, Verify updates

# -------==========-------
# 	HPE Smart Array 
# -------==========-------
# P408i-a SR Gen10
# https://support.hpe.com/connect/s/product?language=en_US&kmpmoid=1010026791&tab=driversAndSoftware
Smart Storage Administrator CLI 6.45.8.0
/opt/smartstorageadmin/ssacli/bin/ssacli
/opt/smartstorageadmin/ssacli/bin/ssacli ctrl all show config detail
/opt/smartstorageadmin/ssacli/bin/ssacli ctrl all show status

# Disable SSD Smart Path
ssacli ctrl slot=0 array A modify ssdsmartpath=disable

# Enable Drive Write Cache
ssacli ctrl slot=0 ld 1 modify caching=enable

# Verify
ssacli ctrl slot=0 ld 1 show detail

# -------==========-------
# HP Ethernet 10Gb 2-port 560FLR-SFP+ Adapter -- END OF SUPPORT
# -------==========-------
https://support.hpe.com/connect/s/product?language=en_US&kmpmoid=5357560
cp056208 5.3.3.30

# -------==========-------
# HPE Ethernet 1Gb 4-port 331i Adapter - NIC
# -------==========-------
https://support.hpe.com/connect/s/softwaredetails?language=en_US&collectionId=MTX-96d916494e7148b0&tab=releaseNotes
https://support.hpe.com/connect/s/softwaredetails?language=en_US&collectionId=MTX-1d81dab4bd3149b1&tab=releaseNotes&softwareId=MTX_16777a31c95d4b8f8ef094a521
# -------==========-------
# 	Host Bus Adapter
# -------==========-------
HPE SN1100Q 16Gb Host Bus Adapter
https://support.hpe.com/connect/s/product?language=en_US&kmpmoid=1009214662&tab=driversAndSoftware