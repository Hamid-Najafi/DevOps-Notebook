# -------==========-------
# Tips
# -------==========-------
mkdir -p ~/dev/traefik 
cp ~/DevOps-Notebook/Apps/Traefik/docker-compose.yml ~/dev/traefik/docker-compose.yml
cp ~/DevOps-Notebook/Apps/Traefik/traefik.yml ~/dev/traefik/traefik.yml
cd ~/dev/traefik 
nano docker-compose.yml 
# Edit
    #   - "traefik.http.routers.traefik.rule=Host(`traefik.goldenstarc.ir`)"

# Set DNS Record
docker-compose up -d