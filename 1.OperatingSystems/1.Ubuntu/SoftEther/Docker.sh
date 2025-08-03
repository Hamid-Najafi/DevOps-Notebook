# -------==========-------
# SoftEther
# -------==========-------
# https://hub.docker.com/r/siomiz/softethervpn/
# -------==========-------
docker run -e PSK=123456789 -e SPW=ServerMngpass.24 -e HPW=HubMngpass.24 -d --cap-add NET_ADMIN -p 443:443/tcp -p 500:500/udp -p 4500:4500/udp -p 1701:1701/tcp -p 1194:1194/udp -p 5555:5555/tcp siomiz/softethervpn
docker run -e PSK=123456789 -e SPW=ServerMngpass.24 -e HPW=HubMngpass.24 -d --cap-add NET_ADMIN -p 500:500/udp -p 4500:4500/udp -p 1701:1701/tcp -p 1194:1194/udp -p 5555:5555/tcp siomiz/softethervpn
