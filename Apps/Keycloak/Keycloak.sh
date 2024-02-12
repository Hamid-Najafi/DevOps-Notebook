# -------==========-------
# keycloak Docker Compose
# -------==========-------
# Make keycloak-data Directory
sudo mkdir -p /mnt/data/keycloak/postgres
# Set Permissions
sudo chmod 750 -R /mnt/data/keycloak
sudo chown -R lxd:docker /mnt/data/keycloak/postgres

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/keycloak/postgres \
      --opt o=bind keycloak-postgres

# Clone Keycloak Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Keycloak ~/docker/keycloak
cd ~/docker/keycloak

# Check and Edit .env file
nano .env

# Create Network and Run
docker network create keycloak-network
docker compose up -d

# -------==========-------
# keycloak Active Directory
# -------==========-------
UI display name: Active Directory
Connection URL: ldap://172.25.10.5
Bind type: simple
Bind DN: CN=Administrator,CN=Users,DC=C1Tech,DC=local
Bind credentials: 
Edit mode: READ_ONLY
Users DN: OU=Users,OU=C1Tech,DC=C1Tech,DC=local
Username LDAP attribute: sAMAccountName
RDN LDAP attribute: cn
UUID LDAP attribute: objectGUID
User object classes: person, organizationalPerson, user
Trust email: On
Mapper Secion ==>
username ==> 
LDAP Attribute: sAMAccountName