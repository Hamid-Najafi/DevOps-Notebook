https://www.keycloak.org/getting-started
# -------==========-------
# Docker
# -------==========-------
https://www.keycloak.org/getting-started/getting-started-docker
https://www.keycloak.org/server/containers
# -------==========-------
docker run -p 8080:8080 -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=admin -d quay.io/keycloak/keycloak:21.1.1 start-dev
# -------==========-------
# Docker-Compose
# -------==========-------
mkdir -p ~/docker/keycloak
cp -R ~/DevOps-Notebook/Apps/Keycloak/*  ~/docker/keycloak
cd  ~/docker/keycloak

nano docker-compose.yml
docker compose up -d

# BaseURL: http://localhost:8080/
# Username: admin
# Password: admin

# -------==========-------
# OpenJDK
# -------==========-------
# Get started with Keycloak on bare metal 