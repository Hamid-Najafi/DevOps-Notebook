# -------==========-------
# Setup
# -------==========-------
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Traefik ~/docker/traefik
cd ~/docker/traefik 
nano docker-compose.yml 
# Set Host
    #   - "traefik.http.routers.traefik.rule=Host(`minio.hamid-najafi.ir`)"
docker network create web
docker-compose up -d

# -------==========-------
# Tips
# -------==========-------
Multi Host
      - "traefik.http.routers.virgol.rule=Host(`lms.legace.ir`, `lms.goldenstarc.ir`)"