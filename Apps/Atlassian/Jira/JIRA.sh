# -------==========-------
# Jira
# -------==========-------
mkdir -p ~/docker/jira
cp -R ~/DevOps-Notebook/Apps/Atlassian/Jira/*  ~/docker/jira
cd  ~/docker/jira

# Make Directories
sudo mkdir -p /mnt/data/jira/jira
sudo mkdir -p /mnt/data/jira/postgresql

# Set Permissions
sudo chmod 775 -R /mnt/data
sudo chown -R $USER:docker /mnt/data

# Create the docker volumes for the containers.
# JIRA
docker volume create --driver local \
     --opt type=none \
     --opt device=/mnt/data/jira/jira \
     --opt o=bind jira-jira-data
# PostgreSQL
docker volume create --driver local \
     --opt type=none \
     --opt device=/mnt/data/jira/postgresql \
     --opt o=bind jira-postgresql-data
# Verify
docker volume list

sudo apt install -y pwgen
# Database Password
pwgen -Bsv1 24
docker-compose up -d

C1Techpass.JC

# -------==========-------
# Atlassian-Agent
# -------==========-------
docker exec jira java -jar /var/agent/atlassian-agent.jar \
    -d \
    -p jira  \
    -m admin@c1tech.group \
    -n admin@c1tech.group \
    -o C1Tech \
    -s BUYC-XDT7-WCBV-7FN1

# -------==========-------
# atlassian-extras-3.4.6.jar
# -------==========-------
docker cp ./atlassian-extras-3.4.6.jar jira:/opt/atlassian/jira/atlassian-jira/WEB-INF/lib/
docker restart jira
http://172.25.10.8:8080/plugins/servlet/applications/versions-licenses
AAAB+g0ODAoPeJyNU12PojAUfedXkOzjBmzRwY+kySriyIo6DrCT9a3iVTrD17bFGffXLwhmPjRmE15o7zn3nHNvv3lFqg5zrmKkImOA+wNkqoFvqQYyDGXPAdIoy3PgustCSAX4xxwWNAFiLedz+9Fyhq5icaCSZemYSiAVUEMdDSPlBmQMIuQsr1AkSGOWMAlbNa4B6uaoRlLmYtBq/Y1YDDrLlDllqYSUpiHYbznjx6Zbr6+hbvkpz4zTs0p7y2rqhevMHd8eK4si2QBf7gIBXBANn8Xd4Mp5ti1CqVc/msh28pVy0C+IbtTSULIDEMkL+JTlx/Mb8FIVtaB0zevSJp5fZePKnKF4xeY9xlOJfaBxcRoG2dFYNPRfiZZ8T1Mm6roq6TJo3G/ruIN1bJg6xr1BDyGsWFkqS7F2GX5MhJ7oz/RAt6y8+rFPyjM9zJK6xUUsjdgpFRGZW8iarKxJ27v/zhLjPnl9Sqcrx/Lcdb4wZv31ygmmeBYf//xOWiNv7XaXuwhPneDhpZV1Ealb/GdqnqS8clr7b8bsjInrjD17obnY7PTv7rq4Y5oIf9qaa4vqAT8AL+Gj0ZOtIfcn1oKlMdEc358pL3A8DwObCHVRr93G117N5T4+FDyMqICvb+Yj+DSxnDPRmC7lkysWmiGdlI+G/j+VCElqMCwCFGxrnjz1G0V5MDwiLbn3gPiP6BUqAhRxlZk+6MN8sZsehGcEYqlhbQxMyg==X02o0