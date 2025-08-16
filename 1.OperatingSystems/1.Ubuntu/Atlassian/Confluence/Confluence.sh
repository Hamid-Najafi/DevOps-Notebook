# -------==========-------
# Confluence
# https://github.com/haxqer/confluence
# -------==========-------

# Clone Confluence Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/1.OperatingSystems/1.Ubuntu/Atlassian/Confluence ~/docker/confluence
cd ~/docker/confluence

# Make Directories
sudo mkdir -p /mnt/data/confluence/confluence
sudo mkdir -p /mnt/data/confluence/postgres

# Set Permissions
Confluene is on UID 1000
postgres is on UID 999

sudo chmod 750 -R /mnt/data/confluence
sudo chown -R 1000:1000 /mnt/data/confluence/confluence
sudo chown -R 999:999 /mnt/data/confluence/postgres

# Create the docker volumes for the containers.
# Confluence
docker volume create --driver local \
     --opt type=none \
     --opt device=/mnt/data/confluence/confluence \
     --opt o=bind confluence-data
# PostgreSQL
docker volume create --driver local \
     --opt type=none \
     --opt device=/mnt/data/confluence/postgres \
     --opt o=bind confluence-postgres
# Verify
# docker volume list

# sudo apt install -y pwgen
# Database Password
# pwgen -Bsv1 24
# nano .env

docker network create confluence-network
docker compose pull
docker compose up -d

# -------==========-------
# *** After RAW Install |OR| UPDATE **** ##
# *** FIX REVERSE PROXY SETTING **** ##
# -------==========-------
# docker cp confluence:/opt/confluence/conf/server.xml server2.xml 
# nano server.xml
docker cp server.xml confluence:/opt/confluence/conf/server.xml
docker compose restart

# -------==========-------
# Active Directory CA LDAPS
# -------==========-------
# Install CA Cert
docker cp ~/C1Tech-MWS-DC-CA.cer confluence:/usr/local/share/ca-certificates/C1TechCA.crt 
docker exec -u 0 confluence sh -c 'echo "172.25.10.10 MWS-DC.C1Tech.local" >> /etc/hosts'
docker exec -u 0 -it confluence keytool -import \
  -alias c1tech-ca \
  -file /usr/local/share/ca-certificates/C1TechCA.crt \
  -keystore /usr/local/openjdk-17/lib/security/cacerts \
  -storepass changeit \
  -noprompt
# Config Directory Service
MWS-DC.C1Tech.local
ConfluenceServiceUser@C1Tech.local
OU=C1Tech,DC=C1Tech,DC=local

# -------==========-------
# Atlassian-Agent
# -------==========-------
docker exec confluence java -jar /var/agent/atlassian-agent.jar \
    -d \
    -p conf \
    -m admin@c1tech.group \
    -n admin@c1tech.group \
    -o C1Tech \
    -s BSYZ-B3Y6-SC4X-91JY

# -------==========-------
#  Atlassian Marketplace
# -------==========-------
# Install Plugin from Atlassian Marketplace.
# Find App Key of Plugin 
# for example biggantt: eu.softwareplant.biggantt
# Execute :

docker exec confluence java -jar /var/agent/atlassian-agent.jar \
    -d \
    -p com.methoda.plugins.rtl-for-confluence \
    -m admin@c1tech.group \
    -n admin@c1tech.group \
    -o C1Tech \
    -s BSYZ-B3Y6-SC4X-91JY

docker exec confluence java -jar /var/agent/atlassian-agent.jar \
    -d \
    -p com.onresolve.confluence.groovy.groovyrunner \
    -m admin@c1tech.group \
    -n admin@c1tech.group \
    -o C1Tech \
    -s BSYZ-B3Y6-SC4X-91JY

docker exec confluence java -jar /var/agent/atlassian-agent.jar \
    -d \
    -p com.mxgraph.confluence.plugins.diagramly \
    -m admin@c1tech.group \
    -n admin@c1tech.group \
    -o C1Tech \
    -s BSYZ-B3Y6-SC4X-91JY

docker exec confluence java -jar /var/agent/atlassian-agent.jar \
    -d \
    -p com.k15t.scroll.scroll-pdf \
    -m admin@c1tech.group \
    -n admin@c1tech.group \
    -o C1Tech \
    -s BSYZ-B3Y6-SC4X-91JY

docker exec confluence java -jar /var/agent/atlassian-agent.jar \
    -d \
    -p com.k15t.scroll.scroll-viewport \
    -m admin@c1tech.group \
    -n admin@c1tech.group \
    -o C1Tech \
    -s BSYZ-B3Y6-SC4X-91JY

docker exec confluence java -jar /var/agent/atlassian-agent.jar \
    -d \
    -p com.k15t.scroll.scroll-office \
    -m admin@c1tech.group \
    -n admin@c1tech.group \
    -o C1Tech \
    -s BSYZ-B3Y6-SC4X-91JY

docker exec confluence java -jar /var/agent/atlassian-agent.jar \
    -d \
    -p com.k15t.scroll.scroll-office \
    -m admin@c1tech.group \
    -n admin@c1tech.group \
    -o C1Tech \
    -s BSYZ-B3Y6-SC4X-91JY