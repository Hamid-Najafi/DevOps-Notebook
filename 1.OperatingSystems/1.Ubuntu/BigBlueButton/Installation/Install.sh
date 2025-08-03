
# ---------------------------------------------------==========---------------------------------------------------------------
# **** DOCKER ! ****
# -------==========-------
# -------==========-------
https://github.com/bigbluebutton/docker
https://github.com/fmp-msu/bbb/blob/traefik/docker-compose.tmpl.yml

    labels:
      - "traefik.enable=true"
      - "traefik.docker.network=traefik-network"
      - "traefik.http.services.bbb-nginx.loadbalancer.server.port=80"
      - "traefik.http.routers.bbb-nginx-http.entrypoints=web"
      - "traefik.http.routers.bbb-nginx-http.rule=Host(`${DOMAIN}`)"
      - "traefik.http.routers.bbb-nginx-https.tls=true"
      - "traefik.http.routers.bbb-nginx-https.tls.certresolver=letsencrypt"
      - "traefik.http.routers.bbb-nginx-https.tls.options=max-tls-12@file"
      - "traefik.http.routers.bbb-nginx-https.entrypoints=websecure"
    networks:
      bbb-net:
        ipv4_address: 10.7.7.34
      - traefik-network


    labels:
      - "traefik.enable=true"
      - "traefik.docker.network=traefik_overlay"
      - "traefik.http.services.bbb-greenlight.loadbalancer.server.port=80"
      - "traefik.http.routers.bbb-greenlight-http.entrypoints=web"
      - "traefik.http.routers.bbb-greenlight-http.rule=Host(`${DOMAIN}`)"
      - "traefik.http.routers.bbb-greenlight-https.tls=true"
      - "traefik.http.routers.bbb-greenlight-https.tls.certresolver=letsencrypt"
      - "traefik.http.routers.bbb-greenlight-https.tls.options=max-tls-12@file"
      - "traefik.http.routers.bbb-greenlight-https.entrypoints=websecure"
      - "traefik.http.routers.bbb-greenlight-https.rule=Host(`${DOMAIN}`) && PathPrefix(`${RELATIVE_URL_ROOT:-/b}`)"

# -------==========-------
# -------==========-------
docker rm -f bbb-exporter
cd ~/bbb-exporter/
docker compose up -d
# ---------------------------------------------------==========---------------------------------------------------------------
# **** Pre Install ****
# -------==========-------
wget https://raw.githubusercontent.com/Hamid-Najafi/DevOps-Notebook/master/Apps/BigBlueButton/Installation/Scripts/PreInstall.sh
chmod +x PreInstall.sh
sudo ./PreInstall.sh

# -------==========-------
# BBB 2.4 + Coturn - Ubuntu 18.04
export FQDN=b1.vir-gol.ir
export version=bionic-24
export email=admin@vir-gol.ir
export turnServer=turn.vir-gol.ir:1b6s1esK
wget -qO- https://ubuntu.bigbluebutton.org/bbb-install.sh | bash -s -- -v  $version -s $FQDN -e $email -g -w -c $turnServer
# -------==========-------
# **** Post Install ****
wget https://raw.githubusercontent.com/Hamid-Najafi/DevOps-Notebook/master/Apps/BigBlueButton/Installation/Scripts/PostInstall.sh
chmod +x PostInstall.sh
sudo ./PostInstall.sh $FQDN
# **** Now Config Recording ****
# ---------------------------------------------------==========---------------------------------------------------------------
# **** Post Upgrade ****
# -------==========-------
wget https://raw.githubusercontent.com/Hamid-Najafi/DevOps-Notebook/master/Apps/BigBlueButton/Installation/Scripts/PostUpgrade.sh
chmod +x PostUpgrade.sh
./PostUpgrade.sh $FQDN
# ---------------------------------------------------==========---------------------------------------------------------------
# Coturn Server - Ubuntu 20.04
# DISABLE PROXY FOR certificate REQUEST
su root
wget https://raw.githubusercontent.com/Hamid-Najafi/DevOps-Notebook/master/Apps/BigBlueButton/Installation/Scripts/PreInstall.sh
chmod +x PreInstall.sh
wget -qO- https://ubuntu.bigbluebutton.org/bbb-install.sh | bash -s -- -c turn.vir-gol.ir:1b6s1esK -e admin@vir-gol.ir
# Verify Turn server is accessible
sudo apt install stun-client
stun turn.vir-gol.ir
# -------==========-------
# Prometheus Main Montoring
# -------==========-------
# run in monitoring server
cd docker/monitoringLite/
nano prometheus/prometheus.yml
# add server address to 'nodeexporter' , 'cadvisor', and 'bbb' Jobs
docker compose up -d --force-recreate --no-deps prometheus
# -------==========-------
# Exporters
# -------==========-------
# Postman or Firefox:
# BBB
curl https://b1.vir-gol.ir/bigbluebutton/api/
https://mconf.github.io/api-mate/#server=https://b3.vir-gol.ir/bigbluebutton/&sharedSecret=1b6s1esKbXNM82ussxx8OHJTenNvfkBu59tkHHADvqk
# Username:admin , Password: Metricpass.24
export FQDN=b3.vir-gol.ir
# BBB Exporter
curl -u admin:Metricpass.24 https://$FQDN/metrics/
# Node Exporter
curl -u admin:Metricpass.24 http://$FQDN:9100/metrics
# CAdvisor
curl -u admin:Metricpass.24 http://$FQDN:9338/containers/
# curl -u admin:Metricpass.24 http://$fqdnHost:8080/containers/
# -------==========-------
# Demo API
# -------==========-------
sudo apt-get install bbb-demo
sudo apt-get purge bbb-demo
# Secret Location
# Version 2.2
sudo nano /var/lib/tomcat7/webapps/demo/bbb_api_conf.jsp
# Version 2.3
sudo nano /var/lib/tomcat8/webapps/demo/bbb_api_conf.jsp
# -------==========-------
# Uninstall
# -------==========-------
# ******** NOTEICE ********
# * Backup all recorded meetings first!
unlink /var/bigbluebutton
# -------==========-------
# Remove BBB Packages - Version 2.3
sudo apt-get purge -y bbb-apps-akka bbb-etherpad bbb-freeswitch-sounds bbb-html5 bbb-mkclean bbb-playback-presentation bbb-web \
bbb-config bbb-freeswitch-core bbb-fsesl-akka bbb-libreoffice-docker bbb-playback bbb-record-core bbb-webrtc-sfu

sudo apt-get purge -y nodejs mongodb-org apt-transport-https haveged build-essential yq
# clean out the local repository
sudo apt-get clean
# remove all the unnecessary packages that are no longer needed
sudo apt autoremove

sudo ufw disable

sudo reboot