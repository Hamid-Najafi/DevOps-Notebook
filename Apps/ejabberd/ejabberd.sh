# -------==========-------
# ejabberd
# -------==========-------
# Robust, Ubiquitous and Massively Scalable Messaging Platform (XMPP, MQTT, SIP Server)
# https://github.com/processone/ejabberd
# https://github.com/processone/docker-ejabberd/tree/master/ecs

sudo certbot certonly --apache # -> for xmpp.hamid-najafi.ir
sudo cp -RL /etc/letsencrypt/live/xmpp.hamid-najafi.ir/ ./cert
sudo chmod 644 ./cert/*
docker run \
    --name ejabberd \
    -p 5222:5222 \
    -p 5280:5280 \
    -p 5443:5443 \
    -p 5269:5269 \
    --restart=always \
    -d ejabberd/ecs
    
        -v ejabberdlogs:/home/ejabberd/logs/ \
    -v ejabberddb:/home/ejabberd/database/ \
    -v $(pwd)/ejabberd.yml:/home/ejabberd/conf/ejabberd.yml \

    # -v $(pwd)/cert:/etc/letsencrypt/live/xmpp.hamid-najafi.ir \

docker exec -it ejabberd bin/ejabberdctl register admin localhost passw0rd

Auth:
admin@localhost
passw0rd

http://IP:5280/admin
http://IP:5280/admin/vhosts
http://IP:5280/admin/server/HOST

# Commands on start
    environment:
      - CTL_ON_CREATE=register admin localhost asd
      - CTL_ON_START=stats registeredusers ;
                     check_password admin localhost asd ;
                     status

# Ports
5222: The default port for XMPP clients.
5269: For XMPP federation. Only needed if you want to communicate with users on other servers.
5280: For admin interface.
5443: With encryption, used for admin interface, API, CAPTCHA, OAuth, Websockets and XMPP BOSH.
1883: Used for MQTT
4369-4399: EPMD and Erlang connectivity, used for ejabberdctl and clustering

# Volumes
/home/ejabberd/conf/: Directory containing configuration and certificates
/home/ejabberd/database/: Directory containing Mnesia database. You should back up or export the content of the directory to persistent storage (host storage, local storage, any storage plugin)
/home/ejabberd/logs/: Directory containing log files
/home/ejabberd/upload/: Directory containing uploaded files. This should also be backed up.