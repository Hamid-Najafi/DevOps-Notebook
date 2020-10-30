# -------==========-------
# ejabberd
# -------==========-------
sudo certbot certonly --apache # -> for xmpp.legace.ir
sudo cp -RL /etc/letsencrypt/live/xmpp.legace.ir/ ./cert
sudo chmod 644 ./cert/*
docker run \
    --name ejabberd \
    -p 5222:5222 \
    -p 5280:5280 \
    -p 5269:5269 \
    -v ejabberdlogs:/home/ejabberd/logs/ \
    -v ejabberddb:/home/ejabberd/database/ \
    -v $(pwd)/cert:/etc/letsencrypt/live/xmpp.legace.ir \
    -v $(pwd)/ejabberd.yml:/home/ejabberd/conf/ejabberd.yml \
    --restart=always \
    -d ejabberd/ecs
    
docker exec -it ejabberd sh  
bin/ejabberdctl register admin xmpp.legace.ir passw0rd