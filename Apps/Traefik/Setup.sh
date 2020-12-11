# -------==========-------
# Tips
# -------==========-------
mkdir -p ~/dev/traefik
cp -R ~/DevOps-Notebook/Apps/Traefik ~/dev/traefik
cd ~/dev/traefik 
nano docker-compose.yml 
# Edit
    #   - "traefik.http.routers.traefik.rule=Host(`traefik.goldenstarc.ir`)"

# Set DNS Record
docker-compose up -d