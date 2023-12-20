# -------==========-------
# Bitbucket
# -------==========-------
mkdir -p ~/docker/bitbucket
cp -R ~/DevOps-Notebook/Apps/Atlassian/Bitbucket/*  ~/docker/bitbucket
cd  ~/docker/bitbucket

# Make Directories
sudo mkdir -p /mnt/data/bitbucket/bitbucket
sudo mkdir -p /mnt/data/bitbucket/postgres

# Set Permissions
sudo chmod 775 -R /mnt/data
sudo chown -R $USER:docker /mnt/data

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

docker compose up -d

http://172.25.10.8:7990/
admin
C1Tech
admin@c1tech.group
C1Techpass.AT

# -------==========-------
# Atlassian-Agent
# -------==========-------
docker exec bitbucket java -jar /var/agent/atlassian-agent.jar \
    -d \
    -p bitbucket \
    -m admin@c1tech.group \
    -n admin@c1tech.group \
    -o C1Tech \
    -s B7G1-FMDZ-FEK1-XQMV

# -------==========-------
# atlassian-extras-3.4.6.jar
# -------==========-------
docker cp ./atlassian-extras-3.4.6.jar bitbucket:/opt/atlassian/bitbucket/atlassian-bitbucket/WEB-INF/lib/
docker restart bitbucket
http://172.25.10.8:8080/plugins/servlet/applications/versions-licenses
AAAB+g0ODAoPeJyNU12PojAUfedXkOzjBmzRwY+kySriyIo6DrCT9a3iVTrD17bFGffXLwhmPjRmE15o7zn3nHNvv3lFqg5zrmKkImOA+wNkqoFvqQYyDGXPAdIoy3PgustCSAX4xxwWNAFiLedz+9Fyhq5icaCSZemYSiAVUEMdDSPlBmQMIuQsr1AkSGOWMAlbNa4B6uaoRlLmYtBq/Y1YDDrLlDllqYSUpiHYbznjx6Zbr6+hbvkpz4zTs0p7y2rqhevMHd8eK4si2QBf7gIBXBANn8Xd4Mp5ti1CqVc/msh28pVy0C+IbtTSULIDEMkL+JTlx/Mb8FIVtaB0zevSJp5fZePKnKF4xeY9xlOJfaBxcRoG2dFYNPRfiZZ8T1Mm6roq6TJo3G/ruIN1bJg6xr1BDyGsWFkqS7F2GX5MhJ7oz/RAt6y8+rFPyjM9zJK6xUUsjdgpFRGZW8iarKxJ27v/zhLjPnl9Sqcrx/Lcdb4wZv31ygmmeBYf//xOWiNv7XaXuwhPneDhpZV1Ealb/GdqnqS8clr7b8bsjInrjD17obnY7PTv7rq4Y5oIf9qaa4vqAT8AL+Gj0ZOtIfcn1oKlMdEc358pL3A8DwObCHVRr93G117N5T4+FDyMqICvb+Yj+DSxnDPRmC7lkysWmiGdlI+G/j+VCElqMCwCFGxrnjz1G0V5MDwiLbn3gPiP6BUqAhRxlZk+6MN8sZsehGcEYqlhbQxMyg==X02o0