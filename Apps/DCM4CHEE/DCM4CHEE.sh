# -------==========-------
# DCM4CHEE Docker Compose
# -------==========-------
# DCM4CHE is a DICOM toolkit. Use it for some command-line tools or to write your own Java, DICOM applications.
# DCM4CHEE is a PACS archive. It is used, primarily, to store images.
# https://github.com/dcm4che/dcm4chee-arc-light/wiki/Running-on-Docker
# -------==========-------

# Make DCM4CHEE Directory
sudo mkdir -p /mnt/data/dcm4chee-arc/wildfly
sudo mkdir -p /mnt/data/dcm4chee-arc/storage
sudo mkdir -p /mnt/data/dcm4chee-arc/ldap
sudo mkdir -p /mnt/data/dcm4chee-arc/slapd
sudo mkdir -p /mnt/data/dcm4chee-arc/postgres

# Set Permissions
sudo chmod 770 -R /mnt/data/dcm4chee-arc
sudo chown -R 1023:1023 /mnt/data/dcm4chee-arc/wildfly
sudo chown -R 1023:1023 /mnt/data/dcm4chee-arc/storage
sudo chown -R 1021:1021 /mnt/data/dcm4chee-arc/ldap
sudo chown -R 1021:1021 /mnt/data/dcm4chee-arc/slapd
sudo chown -R lxd:docker /mnt/data/dcm4chee-arc/postgres

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/dcm4chee-arc/wildfly \
      --opt o=bind dcm4chee-arc-wildfly

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/dcm4chee-arc/storage \
      --opt o=bind dcm4chee-arc-storage

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/dcm4chee-arc/ldap \
      --opt o=bind dcm4chee-arc-ldap

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/dcm4chee-arc/slapd \
      --opt o=bind dcm4chee-arc-slapd

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/dcm4chee-arc/postgres \
      --opt o=bind dcm4chee-arc-postgres
      
# Clone mattermost Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/DCM4CHEE ~/docker/dcm4chee
cd ~/docker/dcm4chee

# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker network create dcm4chee-network
docker compose pull
docker compose up -d

# -------==========-------
# Config and URLs
# -------==========-------
http://dcm4chee.c1tech.group/dcm4chee-arc/ui2

http (8080) and https (8443) port of the web server 
http (9990) and the https (9993) port of the WildFly Administration Console
DICOM (11112), DICOM TLS (2762), HL7 (2575) and HL7 TLS (12575) port of the Archive application 
from the container to the host to enable external http(s) clients, DICOM applications and HL7 senders to connect to WildFly and the Archive application.

AET Title of AE extention named "DCM4CHEE"
http://172.25.10.8:8099/dcm4chee-arc/ui2/en/device/aelist

# -------==========-------
# DCM4CHEE wado
# -------==========-------

wadoUriRoot: 'http://172.25.10.8:8099/dcm4chee-arc/aets/DCM4CHEE/wado',
qidoRoot: 'http://172.25.10.8:8099/dcm4chee-arc/aets/DCM4CHEE/rs',
wadoRoot: 'http://172.25.10.8:8099/dcm4chee-arc/aets/DCM4CHEE/rs',

wadoUriRoot: 'https://dcm4chee.c1tech.group/dcm4chee-arc/aets/DCM4CHEE/wado',
qidoRoot: 'https://dcm4chee.c1tech.group/dcm4chee-arc/aets/DCM4CHEE/rs',
wadoRoot: 'https://dcm4chee.c1tech.group/dcm4chee-arc/aets/DCM4CHEE/rs',
