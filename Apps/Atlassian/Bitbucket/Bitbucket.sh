# -------==========-------
# Bitbucket
# -------==========-------
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Atlassian/Bitbucket ~/docker/bitbucket
cd ~/docker/bitbucket

# Make Directories
sudo mkdir -p /mnt/data/bitbucket/bitbucket
sudo mkdir -p /mnt/data/bitbucket/postgres

# Set Permissions
sudo chmod 750 -R /mnt/data/bitbucket
sudo chown -R root:docker /mnt/data/bitbucket
sudo chown -R lxd:docker /mnt/data/bitbucket/postgres

# Create the docker volumes for the containers.
# Bitbucket
docker volume create --driver local \
     --opt type=none \
     --opt device=/mnt/data/bitbucket/bitbucket \
     --opt o=bind bitbucket-data
# PostgreSQL
docker volume create --driver local \
     --opt type=none \
     --opt device=/mnt/data/bitbucket/postgres \
     --opt o=bind bitbucket-postgres
# Verify
docker volume list

# sudo apt install -y pwgen
# Database Password
# pwgen -Bsv1 24
# nano .env

docker network create bitbucket-network
docker compose up -d

# *** FIX REVERSE PROXY SETTING **** ##
# nano server.xml
docker cp server.xml bitbucket:/opt/bitbucket/conf/server.xml
docker compose restart

# -------==========-------
# Atlassian-Agent
# -------==========-------
docker exec bitbucket java -jar /var/agent/atlassian-agent.jar \
    -d \
    -p bitbucket \
    -m admin@c1tech.group \
    -n admin@c1tech.group \
    -o C1Tech \
    -s BOBR-76ZU-DXL6-JSC5
