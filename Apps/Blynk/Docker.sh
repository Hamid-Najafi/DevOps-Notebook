# -------==========-------
# Blynk
# -------==========-------
wget https://raw.githubusercontent.com/blynkkk/blynk-server/master/server/core/src/main/resources/server.properties

docker run \
    --name=blynk \
    --restart=always \
    -v blynk:/data \
    -p 8080:8080 \
    -p 9443:9443 \
    --network=host \
    -d mpherg/blynk-server

    -v $(PWD)/server.properties:/config/server.properties \

# -------==========-------
# Extended Blynk
# -------==========-------
https://github.com/rb-dock8s/blynk


Build Args

VERSION = 0.41.4 - Blynk Version
Exposed Ports

7443/tcp - Administration UI HTTPS port
8080/tcp - HTTP port
8081/tcp - Web socket ssl/tls port
8082/tcp - Web sockets plain tcp/ip port
8440/tcp - Mqtt hardware server
8441/tcp - Hardware ssl/tls port (for hardware that supports SSL/TLS sockets)
8442/tcp - Hardware plain tcp/ip port
8443/tcp - Application mutual ssl/tls port
9443/tcp - HTTPS port
Volumes

/blynk/data
/blynk/config

Default Admin login email is admin@blynk.cc
Default Admin password is admin
# -------==========-------
# Blynk Raspberry Pi
# -------==========-------

docker run \
    --name=rasbian-blynk \
    --restart=always \
    -v blynk:/data \
    --network=host \
    -p 8080:8080 \
    -p 9443:9443 \
    -d linuxkonsult/rasbian-blynk