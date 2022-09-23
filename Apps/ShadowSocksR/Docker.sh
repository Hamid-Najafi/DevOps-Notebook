# -------==========-------
# ShadowSocksR
# -------==========-------
docker pull teddysun/shadowsocks-r
mkdir -p /etc/shadowsocks-r
cat > /etc/shadowsocks-r/config.json <<EOF
{
    "server":"0.0.0.0",
    "server_ipv6":"::",
    "server_port":8388,
    "local_address":"127.0.0.1",
    "local_port":1080,
    "password":"Shadowpass.24",
    "timeout":120,
    "method":"aes-256-cfb",
    "protocol":"origin",
    "protocol_param":"",
    "obfs":"http_post",
    "obfs_param":"",
    "redirect":"",
    "dns_ipv6":true,
    "fast_open":true,
    "workers":4
}
EOF

docker run -d -p 443:8388 -p 443:8388/udp --name ssr --restart=always -v /etc/shadowsocks-r:/etc/shadowsocks-r teddysun/shadowsocks-r

method: 
1) none
2) aes-256-cfb
3) aes-192-cfb
4) aes-128-cfb
5) aes-256-cfb8
6) aes-192-cfb8
7) aes-128-cfb8
8) aes-256-ctr
9) aes-192-ctr
10) aes-128-ctr
11) chacha20-ietf
12) chacha20
13) salsa20
14) xchacha20
15) xsalsa20
16) rc4-md5

protocol:
1) origin
2) verify_deflate
3) auth_sha1_v4
4) auth_sha1_v4_compatible
5) auth_aes128_md5
6) auth_aes128_sha1
7) auth_chain_a
8) auth_chain_b
9) auth_chain_c
10) auth_chain_d
11) auth_chain_e
12) auth_chain_f

obfuscation technique :
1) plain
2) http_simple
3) http_simple_compatible
4) http_post
5) http_post_compatible
6) tls1.2_ticket_auth
7) tls1.2_ticket_auth_compatible
8) tls1.2_ticket_fastauth
9) tls1.2_ticket_fastauth_compatible