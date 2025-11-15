# -------==========-------
# redsocks
# redsocks – transparent TCP-to-proxy redirector. 
# This tool allows you to redirect any TCP connection to SOCKS or HTTPS proxy using your firewall,
# so redirection may be system-wide or network-wide.
# -------==========-------
# We will redirect incoming traefik from port 12345 to socks port 20170 (Our proxy port)
sudo apt install -y redsocks
cp /etc/redsocks.conf /etc/redsocks.conf.bak;
echo "" > /etc/redsocks.conf;
cat << EOF > /etc/redsocks.conf
base {
  log_debug = on;
  log_info = on;
  log = "file:/var/log/redsocks.log";
  daemon = on;
  redirector = iptables;
}

redsocks {
  local_ip = 0.0.0.0;
  local_port = 12345;
  type = socks5;
  ip = 127.0.0.1;
  port = 54321;
}
EOF

#  Config File location
# /lib/systemd/system/redsocks.service
sudo systemctl restart redsocks
sudo systemctl status redsocks


# Enable IPForwarding
cat /proc/sys/net/ipv4/ip_forward
sysctl -w net.ipv4.ip_forward=1
# Permanent
# nano /etc/sysctl.conf
# net.ipv4.ip_forward=1

# Redirect Incoming Trafik from our client to redsocks
# HP-Z2-Pro.C1Tech.local
sudo iptables -t nat -A PREROUTING -s 172.25.10.240 -p tcp -j REDIRECT --to-ports 12345
# Samsung.C1Tech.local
sudo iptables -t nat -A PREROUTING -s 172.25.10.125 -p tcp -j REDIRECT --to-ports 12345
# 3DP-01P-725.C1Tech.local
sudo iptables -t nat -A PREROUTING -s 172.25.10.28 -p tcp -j REDIRECT --to-ports 12346
# 3DP-01P-896.C1Tech.local
sudo iptables -t nat -A PREROUTING -s 172.25.10.29 -p tcp -j REDIRECT --to-ports 12346


# Verify
sudo iptables -t nat -L PREROUTING -n -v --line-numbers
sudo tail -f /var/log/redsocks.log | grep --color=always '172.25.10.125'

sudo apt install -y iptables-persistent
sudo netfilter-persistent save

# DNS PROXYYYYYYYYYYY
apt install git build-essential
git clone https://github.com/jtripper/dns-tcp-socks-proxy.git /opt/dns-tcp-socks-proxy
nano dns_proxy.conf
/opt/dns-tcp-socks-proxy/dns_proxy /opt/dns-tcp-socks-proxy/dns_proxy.conf
cd /opt/dns-tcp-socks-proxy
make
sudo groupadd -r nobody
sudo useradd -r -g nobody -s /usr/sbin/nologin -d /nonexistent nobody
sudo iptables -t nat -A PREROUTING -s 172.25.10.125 -p udp --dport 53 -j REDIRECT --to-ports 53

# Verify
sudo tcpdump -i any -nnvv port 53
 and host 172.25.10.125

# Proxy Detect
https://proxy.incolumitas.com/proxy_detect.html
# -------==========-------
# Socks5
# -------==========-------
# Start container with proxy
docker run -d --name socks5 -p 1080:1080 -e PROXY_USER=<PROXY_USER> -e PROXY_PASSWORD=<PROXY_PASSWORD> serjs/go-socks5-proxy

docker run -d --name socks5 -p 1080:1080 serjs/go-socks5-proxy

docker run -d --name socks5 -p 1080:1080 -e PROXY_USER=admin -e PROXY_PASSWORD=Socks5pass.24 serjs/go-socks5-proxy

docker run -d --restart=always --name tor-socks-proxy -p 9150:9150/tcp peterdavehello/tor-socks-proxy:latest

# Test running service
curl --socks5 --user <PROXY_USER>:<PROXY_PASSWORD> <docker host ip>:1080 http://ifcfg.co

curl -s --socks5 admin:Socks5pass.24@eu.hamid-najafi.ir:1080 http://ifcfg.co
curl -s --socks5 127.0.0.1:20170 http://google.com 

curl --socks5-hostname su.hamid-najafi.ir:9150 https://ipinfo.tw/ip
curl --socks5-hostname su.hamid-najafi.ir:1080 https://ipinfo.tw/ip
curl --socks5-hostname 127.0.0.1:9150 https://ipinfo.tw/ip
curl --socks5-hostname 127.0.0.1:9150 https://ipinfo.io/ip
curl --socks5-hostname 127.0.0.1:9150 https://icanhazip.com
curl --socks5-hostname 127.0.0.1:9150 https://ipecho.net/plain

docker run --rm curlimages/curl:7.65.3 -s --socks5 <PROXY_USER>:<PROXY_PASSWORD>@<docker host ip>:1080

docker run --rm curlimages/curl:7.65.3 --socks5-hostname eu.hamid-najafi.ir:1080 https://ipinfo.tw/ip
docker run --rm curlimages/curl:7.65.3 -s --socks5 admin:Socks5pass.24@su.hamid-najafi.ir:1080 http://ifcfg.co
docker run --rm curlimages/curl:7.65.3 -x socks5h://admin:Socks5pass.24@su.hamid-najafi.ir:1080 http://ifcfg.co
 $ curl --socks5-hostname 127.0.0.1:9150 https://ipinfo.tw/ip
 $ curl --socks5-hostname 127.0.0.1:9150 https://ipinfo.io/ip
 $ curl --socks5-hostname 127.0.0.1:9150 https://icanhazip.com
 $ curl --socks5-hostname 127.0.0.1:9150 https://ipecho.net/plain
 docker run -d --restart=always --name tor-socks-proxy -p 127.0.0.1:9150:9150/tcp peterdavehello/tor-socks-proxy:latest

# -------==========-------
# Socks5 Over TLS
# -------==========-------