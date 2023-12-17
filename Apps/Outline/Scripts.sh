# -------==========-------
# Outline:
# -------==========-------
# Outgoing SOCKS5 packets are blocked in Irans networks
# Disable HTTP Proxy before Outline installation
wget -qO- https://raw.githubusercontent.com/Jigsaw-Code/outline-server/master/src/server_manager/install_scripts/install_server.sh | sudo bash
# -------==========-------

# -------==========-------
# Note: Outline has its own Prometheus & Exporter
Prometheus is at 127.0.0.1:9090
Node metrics is at 127.0.0.1:9091
outline-ss-server metrics is at 127.0.0.1:9092
