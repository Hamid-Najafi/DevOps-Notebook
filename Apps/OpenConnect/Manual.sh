# -------==========-------
# OpenConnect
# -------==========-------
sudo apt-get update
sudo apt-get install openconnect
echo -e "alias ocn='sudo openconnect --background --user=hamidni --passwd-on-stdin  cau.dnsfinde.com:1397 --http-auth=Basic --servercert pin-sha256:qgYrqhMY2F/Qai+SvtOZRquKqtCa5yaIZXdMQmV/7rY= <<< "641200"'" | sudo tee -a /etc/environment  > /dev/null
echo -e "alias ocf='sudo killall -SIGINT openconnect'" | sudo tee -a /etc/environment > /dev/null
echo -e "alias ipinfo='curl ipinfo.io'" | sudo tee -a /etc/environment > /dev/null
source /etc/environment