# -------==========-------
# Confluence
# -------==========-------
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Atlassian/Confluence ~/docker/confluence
cd ~/docker/confluence

# Make Directories
sudo mkdir -p /mnt/data/confluence/confluence
sudo mkdir -p /mnt/data/confluence/postgres

# Set Permissions
sudo chmod 750 -R /mnt/data/confluence
sudo chown -R $USER:docker /mnt/data/confluence/confluence
sudo chown -R lxd:docker /mnt/data/confluence/postgres

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
docker volume list

# sudo apt install -y pwgen
# Database Password
# pwgen -Bsv1 24
# nano .env

docker network create confluence-network
docker compose up -d

# *** FIX REVERSE PROXY SETTING **** ##
# nano server.xml
docker cp server.xml confluence:/opt/confluence/conf/server.xml

# Disabling secure administrator sessions
docker exec confluence sh -c 'echo "confluence.websudo.is.disabled = true" >>/var/atlassian/application-data/confluence/confluence-config.properties' 
docker exec confluence sh -c 'echo "confluence.websudo.is.disabled = true" >>/var/confluence/confluence-config.properties' 
cd  ~/docker/confluence
docker compose restart


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