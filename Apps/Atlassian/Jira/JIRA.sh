# -------==========-------
# Jira
# -------==========-------
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Atlassian/Jira ~/docker/jira
cd ~/docker/jira


# Make Directories
sudo mkdir -p /mnt/data/jira/jira
sudo mkdir -p /mnt/data/jira/postgres

# Set Permissions
sudo chmod 750 -R /mnt/data/jira/jira
sudo chown -R lxd:docker /mnt/data/jira/jira
sudo chown -R lxd:docker /mnt/data/jira/postgres


# Create the docker volumes for the containers.
# Jira
docker volume create --driver local \
     --opt type=none \
     --opt device=/mnt/data/jira2/jira \
     --opt o=bind jira-data2
# PostgreSQL
docker volume create --driver local \
     --opt type=none \
     --opt device=/mnt/data/jira2/postgres \
     --opt o=bind jira-postgres2
# Verify
docker volume list

# sudo apt install -y pwgen
# Database Password
# pwgen -Bsv1 24
# nano .env

docker network create jira-network
docker compose up -d

# *** FIX REVERSE PROXY SETTING **** ##
# nano server.xml
docker cp server.xml jira:/opt/jira/conf/server.xml

# Disabling secure administrator sessions
docker exec jira sh -c 'echo "jira.websudo.is.disabled = true" >>/var/atlassian/application-data/jira/jira-config.properties' 
docker exec jira sh -c 'echo "jira.websudo.is.disabled = true" >>/var/jira/jira-config.properties' 
docker compose restart
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
C1Tech
admin@c1tech.group
admin
C1Techpass.AT
# -------==========-------
# Atlassian-Agent
# -------==========-------
docker exec jira java -jar /var/agent/atlassian-agent.jar \
    -d \
    -p jira  \
    -m admin@c1tech.group \
    -n admin@c1tech.group \
    -o C1Tech \
    -s BDWG-36B4-SMZ8-99UG

# -------==========-------
# atlassian-extras-3.4.6.jar
# -------==========-------
docker cp ./atlassian-extras-3.4.6.jar jira:/opt/atlassian/jira/atlassian-jira/WEB-INF/lib/
docker restart jira
http://172.25.10.8:8080/plugins/servlet/applications/versions-licenses
AAAB+g0ODAoPeJyNU12PojAUfedXkOzjBmzRwY+kySriyIo6DrCT9a3iVTrD17bFGffXLwhmPjRmE15o7zn3nHNvv3lFqg5zrmKkImOA+wNkqoFvqQYyDGXPAdIoy3PgustCSAX4xxwWNAFiLedz+9Fyhq5icaCSZemYSiAVUEMdDSPlBmQMIuQsr1AkSGOWMAlbNa4B6uaoRlLmYtBq/Y1YDDrLlDllqYSUpiHYbznjx6Zbr6+hbvkpz4zTs0p7y2rqhevMHd8eK4si2QBf7gIBXBANn8Xd4Mp5ti1CqVc/msh28pVy0C+IbtTSULIDEMkL+JTlx/Mb8FIVtaB0zevSJp5fZePKnKF4xeY9xlOJfaBxcRoG2dFYNPRfiZZ8T1Mm6roq6TJo3G/ruIN1bJg6xr1BDyGsWFkqS7F2GX5MhJ7oz/RAt6y8+rFPyjM9zJK6xUUsjdgpFRGZW8iarKxJ27v/zhLjPnl9Sqcrx/Lcdb4wZv31ygmmeBYf//xOWiNv7XaXuwhPneDhpZV1Ealb/GdqnqS8clr7b8bsjInrjD17obnY7PTv7rq4Y5oIf9qaa4vqAT8AL+Gj0ZOtIfcn1oKlMdEc358pL3A8DwObCHVRr93G117N5T4+FDyMqICvb+Yj+DSxnDPRmC7lkysWmiGdlI+G/j+VCElqMCwCFGxrnjz1G0V5MDwiLbn3gPiP6BUqAhRxlZk+6MN8sZsehGcEYqlhbQxMyg==X02o0