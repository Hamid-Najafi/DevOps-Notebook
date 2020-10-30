# -------==========-------
# Matrix
# -------==========-------

cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1
# -> use this code for secret in homeserver.yaml
enable_registration: False
registration_shared_secret: "tobvogqZWk0wtk73VpWIcDtCxOB20CU3"
# -------==========-------
# -------==========-------
docker run -it --rm \
    --mount type=volume,src=synapse-data,dst=/data \
    -e SYNAPSE_SERVER_NAME=matrix.legace.ir \
    -e SYNAPSE_REPORT_STATS=yes \
    matrixdotorg/synapse:latest generate

# sudo nano /var/lib/docker/volumes/synapse-data/_data/homeserver.yaml
sudo cp /var/lib/docker/volumes/synapse-data/_data . -R
sudo chown -R ubuntu:ubuntu _data 
nano _data/homeserver.yaml
# -------==========-------
# Creation of the user synapse and the database synapse  
su - postgres  
createuser synapse  
psql  
ALTER USER synapse WITH ENCRYPTED password 'Synapsepass.24'; 
CREATE DATABASE synapse ENCODING 'UTF8' LC_COLLATE='C' LC_CTYPE='C' template=template0 OWNER synapse;
\q  
exit
# -------==========-------
docker run \
    --name synapse \
    -v $(pwd)/_data:/data \
    --restart=always \
    -p 8008:8008 \
    -d matrixdotorg/synapse:latest

https://matrix.legace.ir

docker run --rm \
-e MATRIX_DOMAIN=matrix.legace.ir \
-v /data/ma1sd/etc:/etc/ma1sd \
-v /data/ma1sd/var:/var/ma1sd \
-p 8090:8090 \
-t ma1uta/ma1sd
nano /data/ma1sd/etc/ma1sd.yaml

docker run \
    --name riot-web \
    -p 8084:80 \
    -v $(pwd)/config.json:/etc/riot-web/config.json:ro \
    --restart=always \
    -d bubuntux/riot-web

docker run \
    --name riot-web \
    -p 8084:80 \
    -v $(pwd)/config.json:/app/config.json \
    --restart=always \
    -d vectorim/riot-web


# --mount type=volume,src=synapse-data,dst=/data \
