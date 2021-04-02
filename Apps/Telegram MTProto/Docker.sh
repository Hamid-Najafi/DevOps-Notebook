# -------==========-------
# Telegram MTProto
# -------==========-------

# Clone repository
mkdir -p ~/docker/mtproto
git clone https://github.com/Hamid-Najafi/docker-compose-mtproxy.git ~/docker/mtproto

# Edit config.env
# TAG Value, for promote channel
# Preset SECRET, UP TO 16
# Secret count for generate, UP TO 16
# Workers count
cd ~/docker/mtproto
nano config.env
# run proxy
docker-compose up -d
# show logs and connections info
docker-compose logs -f