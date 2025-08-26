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