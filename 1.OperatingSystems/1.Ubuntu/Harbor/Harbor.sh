# -------==========-------
# Harbor
# -------==========-------
mkdir ~/docker
cd ~/docker
# Download either the online or offline installer for the version you want to install.
# https://github.com/goharbor/harbor/releases
wget https://github.com/goharbor/harbor/releases/download/v2.13.2/harbor-online-installer-v2.13.2.tgz
wget https://github.com/goharbor/harbor/releases/download/v2.13.2/harbor-offline-installer-v2.13.2.tgz

tar xvzf harbor-online-installer-v2.13.2.tgz
rm harbor-offline-installer-v2.13.2.tgz 
cd harbor
nano harbor.yml
sudo mkdir /mnt/data/harbor/

# HTTPS options 1. Use Labels.
sudo nano docker-compose.yml
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.harbor.rule=Host(`harbor.c1tech.group`)"
      - "traefik.http.routers.harbor.entrypoints=websecure"
      - "traefik.http.routers.harbor.tls=true"
      - "traefik.http.routers.harbor.tls.certresolver=letsencrypt"
      - "traefik.http.services.harbor.loadbalancer.server.port=80"
      - "traefik.http.services.harbor.loadbalancer.passhostheader=true"
networks:
  traefik-network:
    external: true
# HTTPS options 2. use dynamic config to this ip
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}'  nginx 

# sudo chown $USER:$USER -R  /mnt/data/harbor/
# sudo chown 10000 -R /mnt/data/harbor
# sudo chmod 644 /mnt/data/harbor/common/config/db/env
# sudo 10000 /mnt/data/harbor/
sudo ./install.sh --with-trivy

## HARBOR ONLY DO LOGIN IN URL MATCH not locally ip
https://registry.c1tech.group/account/sign-in?redirect_url=%2Fharbor%2Fprojects
# -------==========-------
# Authentik Integrations
# -------==========-------
How to change auth mode when the auth_mode is not editable?
https://github.com/goharbor/harbor/wiki/harbor-faqs#authentication


https://integrations.goauthentik.io/infrastructure/harbor/

# -------==========-------
# Verify Docker Registry
# -------==========-------
docker login registry.c1tech.group

nano Dockerfile
# Dockerfile
FROM alpine:latest
CMD ["echo", "Hello from test image!"]

docker build -t registry.c1tech.group/library/example:1.0 .
docker push registry.c1tech.group/library/example:1.0
docker pull registry.c1tech.group/library/example:1.0
docker run --rm registry.c1tech.group/library/example:1.0

