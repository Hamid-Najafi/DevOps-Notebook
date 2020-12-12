# -------==========-------
# Tips
# -------==========-------
mkdir -p ~/dev
cp -R ~/DevOps-Notebook/Apps/Traefik ~/dev/traefik
cd ~/dev/traefik 
nano docker-compose.yml 
# Set DNS Record
# Edit
    #   - "traefik.http.routers.traefik.rule=Host(`traefik.goldenstarc.ir`)"
docker network create web
docker-compose up -d