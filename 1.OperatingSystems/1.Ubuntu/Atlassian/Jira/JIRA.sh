# -------==========-------
# Jira
# https://github.com/haxqer/jira
# -------==========-------

# Clone JIRA Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/1.OperatingSystems/1.Ubuntu/Atlassian/Jira ~/docker/jira
cd ~/docker/jira

# Make Directories
sudo mkdir -p /mnt/data/jira/jira
sudo mkdir -p /mnt/data/jira/postgres

# Set Permissions
docker exec -it jira id
docker exec -it jira-postgres id postgres

sudo chmod 700 -R /mnt/data/jira
sudo chown -R 999:999 /mnt/data/jira/jira
sudo chown -R 999:999 /mnt/data/jira/postgres


# Create the docker volumes for the containers.
# Jira
docker volume create --driver local \
     --opt type=none \
     --opt device=/mnt/data/jira/jira \
     --opt o=bind jira-data
# PostgreSQL
docker volume create --driver local \
     --opt type=none \
     --opt device=/mnt/data/jira/postgres \
     --opt o=bind jira-postgres
# Verify
# docker volume list

# sudo apt install -y pwgen
# Database Password
# pwgen -Bsv1 24
# nano .env

docker network create jira-network
docker compose pull
docker compose up -d

# -------==========-------
# *** After RAW Install |OR| UPDATE **** ##
# *** FIX REVERSE PROXY SETTING **** ##
# -------==========-------
# docker cp jira:/opt/jira/conf/server.xml server2.xml 
# nano server.xml
docker cp server.xml jira:/opt/jira/conf/server.xml
docker compose restart

# -------==========-------
# Authentik Integrations
# -------==========-------
Providor Scopes: email, offline_access, openid, profile
Username mapping: ${sub} # Based on Users username
Additional scopes: offline_access
JIT: Enabled
Display name: ${name}
Email: ${email}
Groups: groups
JIT Scopes: profile, email
# if any thing goes wrong...!
# Enable auth fallabck and login form...
curl -vvv -k -L -u admin:password -X PATCH https://jira.c1tech.group/rest/authconfig/1.0/sso \
    -H 'Content-Type: application/json'\
    -d '{"show-login-form": true, "enable-authentication-fallback":true}'
# -------==========-------
# Live Logs
# -------==========-------
sudo tail -f /mnt/data/jira/jira/log/atlassian-jira.log

# -------==========-------
#  Disabling secure administrator
# -------==========-------
docker exec jira sh -c 'echo "jira.websudo.is.disabled = true" >>/var/atlassian/application-data/jira/jira-config.properties' 
docker exec jira sh -c 'echo "jira.websudo.is.disabled = true" >>/var/jira/jira-config.properties' 
docker compose restart

# -------==========-------
# Active Directory CA LDAPS
# -------==========-------
# Install CA Cert
docker cp ~/C1Tech-MWS-DC-CA.cer jira:/usr/local/share/ca-certificates/C1TechCA.crt 
docker exec -u 0 jira sh -c 'echo "172.25.10.10 MWS-DC.C1Tech.local" >> /etc/hosts'
docker exec -u 0 -it jira keytool -import \
  -alias c1tech-ca \
  -file /usr/local/share/ca-certificates/C1TechCA.crt \
  -keystore /usr/local/openjdk-17/lib/security/cacerts \
  -storepass changeit \
  -noprompt
# Config Directory Service
MWS-DC.C1Tech.local
JiraServiceUser@C1Tech.local
ConfluenceServiceUser@C1Tech.local
OU=C1Tech,DC=C1Tech,DC=local

# -------==========-------
# Jira Key
# -------==========-------
docker exec jira java -jar /var/agent/atlassian-agent.jar \
    -d \
    -p jira  \
    -m admin@c1tech.group \
    -n admin@c1tech.group \
    -o C1Tech \
    -s BDWG-36B4-SMZ8-99UG

# -------==========-------
# Jira Service Management(jsm) Plugin Key
# -------==========-------

docker exec jira java -jar /var/agent/atlassian-agent.jar \
    -d \
    -p jsm \
    -m admin@c1tech.group \
    -n admin@c1tech.group \
    -o C1Tech \
    -s BDWG-36B4-SMZ8-99UG

# -------==========-------
#  Atlassian Marketplace
# -------==========-------
# Install Plugin from Atlassian Marketplace.
# Find App Key of Plugin 
# for example biggantt: eu.softwareplant.biggantt
# Execute :

docker exec jira java -jar /var/agent/atlassian-agent.jar \
    -d \
    -p eu.softwareplant.bigpicture \
    -m admin@c1tech.group \
    -n admin@c1tech.group \
    -o C1Tech \
    -s BDWG-36B4-SMZ8-99UG

docker exec jira java -jar /var/agent/atlassian-agent.jar \
    -d \
    -p eu.softwareplant.biggantt \
    -m admin@c1tech.group \
    -n admin@c1tech.group \
    -o C1Tech \
    -s BDWG-36B4-SMZ8-99UG

docker exec jira java -jar /var/agent/atlassian-agent.jar \
    -d \
    -p softwareplant.bigtemplate \
    -m admin@c1tech.group \
    -n admin@c1tech.group \
    -o C1Tech \
    -s BDWG-36B4-SMZ8-99UG

docker exec jira java -jar /var/agent/atlassian-agent.jar \
    -d \
    -p com.infosysta.jira.translation.arabic \
    -m admin@c1tech.group \
    -n admin@c1tech.group \
    -o C1Tech \
    -s BDWG-36B4-SMZ8-99UG

docker exec jira java -jar /var/agent/atlassian-agent.jar \
    -d \
    -p com.onresolve.jira.groovy.groovyrunner \
    -m admin@c1tech.group \
    -n admin@c1tech.group \
    -o C1Tech \
    -s BDWG-36B4-SMZ8-99UG

docker exec jira java -jar /var/agent/atlassian-agent.jar \
    -d \
    -p com.jiraeditor.jeditor \
    -m admin@c1tech.group \
    -n admin@c1tech.group \
    -o C1Tech \
    -s BDWG-36B4-SMZ8-99UG

docker exec jira java -jar /var/agent/atlassian-agent.jar \
    -d \
    -p com.inboxforjira.inbox \
    -m admin@c1tech.group \
    -n admin@c1tech.group \
    -o C1Tech \
    -s BDWG-36B4-SMZ8-99UG


docker exec jira java -jar /var/agent/atlassian-agent.jar \
    -d \
    -p com.whitesoftware.jira.groupee-group-assignee \
    -m admin@c1tech.group \
    -n admin@c1tech.group \
    -o C1Tech \
    -s BDWG-36B4-SMZ8-99UG


# -------==========-------
# GitLan Integration
# -------==========-------
# tl;dr
https://gitlab.c1tech.group/groups/software-group/-/settings/integrations

# -------==========-------
# atlassian-extras-3.4.6.jar
# -------==========-------
docker cp ./atlassian-extras-3.4.6.jar jira:/opt/atlassian/jira/atlassian-jira/WEB-INF/lib/
docker restart jira
http://172.25.10.8:8080/plugins/servlet/applications/versions-licenses
AAAB+g0ODAoPeJyNU12PojAUfedXkOzjBmzRwY+kySriyIo6DrCT9a3iVTrD17bFGffXLwhmPjRmE15o7zn3nHNvv3lFqg5zrmKkImOA+wNkqoFvqQYyDGXPAdIoy3PgustCSAX4xxwWNAFiLedz+9Fyhq5icaCSZemYSiAVUEMdDSPlBmQMIuQsr1AkSGOWMAlbNa4B6uaoRlLmYtBq/Y1YDDrLlDllqYSUpiHYbznjx6Zbr6+hbvkpz4zTs0p7y2rqhevMHd8eK4si2QBf7gIBXBANn8Xd4Mp5ti1CqVc/msh28pVy0C+IbtTSULIDEMkL+JTlx/Mb8FIVtaB0zevSJp5fZePKnKF4xeY9xlOJfaBxcRoG2dFYNPRfiZZ8T1Mm6roq6TJo3G/ruIN1bJg6xr1BDyGsWFkqS7F2GX5MhJ7oz/RAt6y8+rFPyjM9zJK6xUUsjdgpFRGZW8iarKxJ27v/zhLjPnl9Sqcrx/Lcdb4wZv31ygmmeBYf//xOWiNv7XaXuwhPneDhpZV1Ealb/GdqnqS8clr7b8bsjInrjD17obnY7PTv7rq4Y5oIf9qaa4vqAT8AL+Gj0ZOtIfcn1oKlMdEc358pL3A8DwObCHVRr93G117N5T4+FDyMqICvb+Yj+DSxnDPRmC7lkysWmiGdlI+G/j+VCElqMCwCFGxrnjz1G0V5MDwiLbn3gPiP6BUqAhRxlZk+6MN8sZsehGcEYqlhbQxMyg==X02o0