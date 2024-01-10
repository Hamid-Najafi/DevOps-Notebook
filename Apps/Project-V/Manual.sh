# -------==========-------
# Project V
# -------==========-------
# ProxySU - SIMPLE WAY TO CONFIG ALL Cores
# V2ray, Xray, Trojan, NaiveProxy, Trojan-Go, MTProto Go, Brook,BBR install tools for windows。
# -------==========-------
https://github.com/proxysu/ProxySU
# -------==========-------
# V2RayA Client
# -------==========-------

# -------==========-------
docker run -d \
  --restart=always \
  --privileged \
  --network=host \
  --name v2raya \
  -e V2RAYA_ADDRESS=0.0.0.0:2017 \
  -e V2RAYA_LOG_FILE=/tmp/v2raya.log \
  -e V2RAYA_V2RAY_BIN=/usr/local/bin/xray \
  -e V2RAYA_NFTABLES_SUPPORT=off \
  -v /lib/modules:/lib/modules:ro \
  -v /etc/resolv.conf:/etc/resolv.conf \
  -v /etc/v2raya:/etc/v2raya \
  mzz2017/v2raya
# -------==========-------
V2RayX for macOS
https://github.com/Cenmrev/V2RayX/releases
v2rayN for Windows
https://github.com/2dust/v2rayN/releases
OneClick for iOS
https://apps.apple.com/sr/app/oneclick-safe-easy-fast/id1545555197
v2rayNG for Android
https://github.com/2dust/v2rayNG