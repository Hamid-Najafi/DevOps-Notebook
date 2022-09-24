# -------==========-------
# OpenWrt
# -------==========-------
SSID:	MikroTik RB951Ui-2HnD
Password: MikroTikpass.24
# -------==========-------
ssh root@192.168.1.1
root
# -------==========-------
# OpenVPN Client
# -------==========-------
opkg update
opkg install openvpn-openssl luci-app-openvpn 