# -------==========-------
# APT Proxy
# -------==========-------

cat >>  /etc/apt/apt.conf << EOF
Acquire::http::Proxy "http://172.25.10.21:10809";
Acquire::https::Proxy "http://172.25.10.21:10809";
EOF
