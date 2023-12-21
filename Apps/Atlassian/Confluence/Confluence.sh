# -------==========-------
# Confluence
# -------==========-------
mkdir -p ~/docker/confluence
cp -R ~/DevOps-Notebook/Apps/Atlassian/Confluence/*  ~/docker/confluence
cd  ~/docker/confluence

# Make Directories
sudo mkdir -p /mnt/data/confluence/confluence
sudo mkdir -p /mnt/data/confluence/postgres

# Set Permissions
sudo chmod 770 -R /mnt/data/confluence
sudo chown -R $USER:docker /mnt/data/confluence

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

# -------==========-------
C1Tech
admin@c1tech.group
admin
C1Techpass.AT
# -------==========-------
# Login localy and set Base url after first setup:
# https://jira.c1tech.group
To configure the base URL:
In the upper-right corner of the screen, select Administration  > System.
In the sidebar, select General configuration.
Select Edit settings.
Enter the new URL in the Base URL text box.
Select Update to save your changes.
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