# -------==========-------
# Traefik Docker Compose
# -------==========-------
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Traefik ~/docker/traefik
cd ~/docker/traefik 
# nano docker-compose.yml 
# Set Host
    #   - "traefik.http.routers.traefik.rule=Host(`hamid-najafi.ir`)"
docker network create web
docker-compose up -d
# Note: Check firewall & mapping rules for Port: 80 & 443
# -------==========-------
# Prometheus
# -------==========-------
export FQDN=hr.hamid-najafi.ir
curl -u traefik:Traefikpass.24 http://$FQDN:9094/metrics/

# -------==========-------
# Tips
# -------==========-------
# Multi Host
      - "traefik.http.routers.virgol.rule=Host(`s1.hamid-najafi.ir`, `s2.c1tech.group`)"


# Grafana
https://grafana.com/grafana/dashboards/12250

docker exec -it grafana grafana-cli plugins install grafana-piechart-panel  
docker restart grafana

