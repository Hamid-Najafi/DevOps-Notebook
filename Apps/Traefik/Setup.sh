# -------==========-------
# Tips
# -------==========-------
mkdir -p ~/docker/traefik 
cp ~/devops-notebook/Apps/Traefik/docker-compose.yml ~/docker/traefik/docker-compose.yml
cp ~/devops-notebook/Apps/Traefik/traefik.yml ~/docker/traefik/traefik.yml
cd ~/docker/traefik 
docker-compose up -d