# -------==========-------
# OpenWrt installation
# -------==========-------
# https://openwrt.org/toh/mikrotik/common
# -------==========-------
# Preparing Files for TFTP Net Booting
# If your machine is connected to a local area network, you may be able to boot it over the network from another machine, using TFTP. If you intend to boot the installation system from another machine, the boot files will need to be placed in specific locations on that machine, and the machine configured to support booting of your specific machine.
# You need to setup a TFTP server, and for many machines a DHCP server, or BOOTP server.
# BOOTP is an IP protocol that informs a computer of its IP address and where on the network to obtain a boot image. The DHCP (Dynamic Host Configuration Protocol) is a more flexible, backwards-compatible extension of BOOTP. Some systems can only be configured via DHCP.
# For PowerPC, if you have a NewWorld Power Macintosh machine, it is a good idea to use DHCP instead of BOOTP. Some of the latest machines are unable to boot using BOOTP.
# The Trivial File Transfer Protocol (TFTP) is used to serve the boot image to the client. Theoretically, any server, on any platform, which implements these protocols, may be used. In the examples in this section, we shall provide commands for SunOS 4.x, SunOS 5.x (a.k.a. Solaris), and GNU/Linux.
# -------==========-------
# 1.(optional) Save the license key of RouterOS and the original firmware.
# 2.Downgrade to RouterOS v6 if you previously upgraded to v7.
# 3.Boot router via network boot (BOOTP/TFTP or DHCP/TFTP) for testing. OpenWrt isn't installed now, it's working from a RAM image. If it doesn't work, try a different version of OpenWrt.
# 4.If all right, write OpenWrt into flash of the router, then reboot.
# 5.Tuning OpenWrt.
# -------==========-------
