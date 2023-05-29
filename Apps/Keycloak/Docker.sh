https://www.keycloak.org/getting-started
# -------==========-------
# Docker
# -------==========-------
https://www.keycloak.org/getting-started/getting-started-docker
# -------==========-------
docker run -p 8080:8080 -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=admin quay.io/keycloak/keycloak:21.1.1 start-dev
# -------==========-------
# Docker-Compose
# -------==========-------
# Setup traefik
mkdir -p ~/docker/keycloak
cp -R ~/DevOps-Notebook/Apps/Keycloak/*  ~/docker/keycloak
cd  ~/docker/keycloak

nano docker-compose.yml
docker-compose up -d
# -------==========-------
# OpenJDK
# -------==========-------
# Get started with Keycloak on bare metal 