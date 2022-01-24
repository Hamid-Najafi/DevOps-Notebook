# -------==========-------
# **** Pre Install ****
su root
wget https://raw.githubusercontent.com/Hamid-Najafi/DevOps-Notebook/master/Apps/BigBlueButton/Installation/Scripts/PreInstall.sh
chmod +x PreInstall.sh
# -------==========-------
# "Configure FQDN"
echo -e "FQDN=b2.vir-gol.ir" | sudo tee -a /etc/environment
source /etc/environment
# -------==========-------
# BBB 2.4 + Coturn - Ubuntu 18.04
wget -qO- https://ubuntu.bigbluebutton.org/bbb-install.sh | bash -s -- -v bionic-24  -s $FQDN -e admin@vir-gol.ir -g -w -c turn.vir-gol.ir:1b6s1esK
# wget -qO- https://ubuntu.bigbluebutton.org/bbb-install.sh | bash -s -- -v bionic-230 -s $FQDN -e admin@vir-gol.ir -g -w -c turn.vir-gol.ir:1b6s1esK

# BBB 2.3 - Ubuntu 18.04
# wget -qO- http://ubuntu.bigbluebutton.org/bbb-install.sh | bash -s -- -v bionic-23 -s $FQDN -e admin@vir-gol.ir -g -w
# -------==========-------
# **** Post Install ****
wget https://raw.githubusercontent.com/Hamid-Najafi/DevOps-Notebook/master/Apps/BigBlueButton/Installation/Scripts/PostInstall.sh
chmod +x PostInstall.sh
sudo ./PostInstall.sh $FQDN
# **** Config Recording ****
# -------==========-------
# -------==========-------
# **** Post Upgrade ****
# -------==========-------
# -------==========-------
su root
wget https://raw.githubusercontent.com/Hamid-Najafi/DevOps-Notebook/master/Apps/BigBlueButton/Installation/Scripts/PostUpgrade.sh
chmod +x PostUpgrade.sh
./PostUpgrade.sh $FQDN
# -------==========-------
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
# BBB 2.2 - Ubuntu 16.04
# wget -qO- https://ubuntu.bigbluebutton.org/bbb-install.sh | sudo bash -s -- -v xenial-22 -s $FQDN -e admin@vir-gol.ir -g -w

# BBB 2.2 specific version + Coturn - Ubuntu 16.04
# wget -qO- https://ubuntu.bigbluebutton.org/bbb-install.sh | sudo bash -s -- -v xenial-220-2.2.29 -s $FQDN -e admin@vir-gol.ir -g -w -c turn.vir-gol.ir:1b6s1esK
# -------==========-------
# Prometheus Main Montoring
# -------==========-------
# run in monitoring server
cd docker/monitoringLite/
nano prometheus/prometheus.yml
# add server address to 'nodeexporter' , 'cadvisor', and 'bbb' Jobs
docker-compose up -d --force-recreate --no-deps prometheus
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