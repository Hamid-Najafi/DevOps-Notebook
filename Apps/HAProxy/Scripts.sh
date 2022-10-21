# -------==========-------
# HAProxy
# -------==========-------
sudo apt update
sudo apt install haproxy -y
sudo nano /etc/haproxy/haproxy.cfg
# copy and paste the following lines to the end of the file. 
frontend https
   bind 37.32.21.73:443
   mode tcp
   tcp-request inspect-delay 5s
   tcp-request content accept if { req_ssl_hello_type 1 }

   use_backend ocserv if { req_ssl_sni -i goldenstarc.ir }
   use_backend nginx if { req_ssl_sni -i www.hamid-najafi.ir }
   use_backend nginx if { req_ssl_sni -i hamid-najafi.ir }

   default_backend ocserv

backend ocserv
   mode tcp
   option ssl-hello-chk
   # pass requests to 127.0.0.1:443. Proxy protocol (v2) header is required by ocserv.
   server ocserv 127.0.0.1:443 send-proxy-v2

backend nginx
   mode tcp
   option ssl-hello-chk
   server nginx 127.0.0.2:443 check

sudo systemctl restart haproxy
sudo systemctl status haproxy