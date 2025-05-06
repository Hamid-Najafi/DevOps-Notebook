# -------==========-------
# Smart SNI and DNS Proxy Server
# https://github.com/dlundquist/sniproxy
# -------==========-------
# https://github.com/Gharib110/SniProxy/tree/main

# Building Debian/Ubuntu package and config for SNIProxy
git clone https://github.com/dlundquist/sniproxy.git
cd sniproxy
sudo apt-get install autotools-dev cdbs debhelper dh-autoreconf dpkg-dev gettext libev-dev libpcre2-dev libudns-dev pkg-config fakeroot devscripts
./autogen.sh && dpkg-buildpackage
sudo dpkg -i ../sniproxy_<version>_<arch>.deb
touch /etc/sniproxy.conf;
cat << EOF > /etc/sniproxy.conf
user daemon
pidfile /var/run/sniproxy.pid
resolver {
        nameserver 1.1.1.1
        nameserver 8.8.8.8
        mode ipv4_only
}
#listener 80 {
#       proto http
#}
listener 443 {
        proto tls
}
table {
        .* *
}
EOF
# Service File for SNIProxy
touch /usr/lib/systemd/system/sniproxy.service;
cat << EOF > /usr/lib/systemd/system/sniproxy.service
    [Unit]
Description=SNI Proxy Service
After=network.target

[Service]
Type=forking
ExecStart=/usr/sbin/sniproxy -c /etc/sniproxy.conf

[Install]
WantedBy=multi-user.target
EOF

# Install dnsmasq
apt install -y dnsmasq
echo "" > /etc/dnsmasq.conf;
cat << EOF > /etc/dnsmasq.conf
conf-dir=/etc/dnsmasq.d/,*.conf
cache-size=100000
no-resolv
server=1.1.1.1
server=8.8.8.8
interface=eth0
interface=lo
EOF

# Install nginx
apt install -y nginx;
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak;
echo "" > /etc/nginx/nginx.conf;
cat << EOF > /etc/nginx/nginx.conf
# user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

        include /etc/nginx/conf.d/*.conf;

    server {
        listen       80 default_server;
        server_name  _;
        root         /usr/share/nginx/html;

        include /etc/nginx/default.d/*.conf;

        location / {
            rewrite ^ $http_x_forwarded_proto://$host$request_uri permanent;
        }

        error_page 404 /404.html;
            location = /40x.html {
        }

        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
    }
}
EOF

# Config Services
systemctl enable sniproxy && systemctl enable dnsmasq && systemctl enable nginx;
systemctl start sniproxy && systemctl start dnsmasq && systemctl start nginx;

# -------==========-------
# Specify domains
# -------==========-------
# DNS All rquests
echo "" > /etc/dnsmasq.d/sni.conf;
cat << EOF > /etc/dnsmasq.d/sni.conf
    address=/#/ipserver
EOF

# DNS Signle Domains
nano /etc/dnsmasq.d/sni.conf
address=/.domaion.com/ipserver

# DNS Suspended
https://gist.githubusercontent.com/asefsoft/eee71f3df313cbf50b8c7a90278df71f/raw/11ef9f0b11967a1063875f8eb0778a57023d15b1/list_of_blocked_sites.md
