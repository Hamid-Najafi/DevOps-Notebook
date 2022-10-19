# -------==========-------
# ShadowSocksR
# -------==========-------
# Docker-Compose
# -------==========-------
mkdir -p ~/docker/shadowsocks-r
cp ~/DevOps-Notebook/Apps/ShadowSocksR/* ~/docker/shadowsocks-r
cd ~/docker/shadowsocks-r
# Config if needed
nano config.json
docker-compose up -d

# -------==========-------
# Docker
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

docker run -d -p 8388:8388/tcp -p 8388:8388/udp --name ssr --restart=always -v /etc/shadowsocks-r:/etc/shadowsocks-r teddysun/shadowsocks-r

# -------==========-------
# Client
# -------==========-------
# https://github.com/shadowsocksrr/electron-ssr
# https://github.com/TyrantLucifer/ssr-command-client
sudo apt update
sudo apt install python3 python3-pip python-is-python3 -y
git clone https://github.com/TyrantLucifer/ssr-command-client.git
cd ssr-command-client
sudo python3 setup.py install
sudo pip3 install shadowsocksr-cli
shadowsocksr-cli --add-ssr ssr://URL
shadowsocksr-cli --add-ssr ssr://OTEuMTk4Ljc3LjE2NTo4Mzg4Om9yaWdpbjphZXMtMjU2LWNmYjpodHRwX3Bvc3Q6VTJoaFpHOTNjR0Z6Y3k0eU5BLz9vYmZzcGFyYW09Jmdyb3VwPVJHVm1ZWFZzZENCSGNtOTFjQSZ1b3Q9MSZ1ZHBwb3J0PTgzODg
shadowsocksr-cli -l
shadowsocksr-cli -s 3
# ALWAYS-ON
echo -e "export ALL_PROXY=socks5://127.0.0.1:1080" | sudo tee -a ~/.bashrc
source ~/.bashrc

# OPTIONAL ON/OFF
echo -e "alias setproxy=\"export ALL_PROXY=socks5://127.0.0.1:1080\"\nalias unsetproxy=\"unset ALL_PROXY\"\nalias ip=\"curl http://ip-api.com/json/?lang=zh-CN\"" | sudo tee -a ~/.bashrc
source ~/.bashrc
# -------==========-------
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