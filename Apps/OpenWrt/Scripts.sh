# -------==========-------
# OpenWrt
# -------==========-------
SSID:	MikroTik RB951Ui-2HnD
Password: MikroTikpass.24
# -------==========-------
ssh root@192.168.1.1
root
# -------==========-------
# SSR Client
# -------==========-------
opkg install shadowsocks-libev-ss-local shadowsocks-libev-ss-redir shadowsocks-libev-ss-rules shadowsocks-libev-ss-tunnel
opkg install luci-app-shadowsocks-libev

# -------==========-------
# OpenVPN Client
# -------==========-------
# CLI & LuCI packages
opkg update
opkg install openvpn-openssl luci-app-openvpn 


# -------==========-------
# OpenConnect Client
# -------==========-------
https://behroozam.medium.com/raspberry-pi-openwrt-openconnect-lan-connection-91ce9a17568d
# CLI & LuCI packages
opkg update
opkg install openconnect luci-proto-openconnect openssl-util
/etc/init.d/rpcd restart




# getting SHA-1 from your openconnect server
export OC_SERV="hamid-najafi.ir"
openssl s_client -connect goldenstarc.ir:443 -showcerts 2>/dev/null </dev/null | awk '/-----BEGIN/,/-----END/ { print $0 }' | openssl x509 -noout -fingerprint -sha1 | sed 's/Fingerprint=//' | sed 's/://g'
# SHA1 70BD1F16B9136F679E2BE31D1E346E2B44CB1193
# admin
# ocservpass.24
after booting up going to network > interface and setup a new interface and setup OpenConnect interface.
# -------==========-------
# OpenConnect Server
# -------==========-------
# Certificate hash
# Install packages
opkg update
opkg install openssl-util
 
# Generate certificate hash
opkg update
opkg install openssl-util
OC_HASH="$(echo pin-sha256:\
$(openssl x509 -in /etc/ocserv/server-cert.pem -pubkey -noout \
| openssl pkey -pubin -outform der \
| openssl dgst -sha256 -binary \
| openssl enc -base64))"
# Fetch certificate hash
echo ${OC_HASH}

# Configuration parameters
OC_IF="NLOCServ"
OC_SERV="nl.hamid-najafi.ir"
OC_PORT="443"
OC_USER="ocuser"
OC_PASS="ocuser"
OC_HASH="SERVER_CERT_HASH"