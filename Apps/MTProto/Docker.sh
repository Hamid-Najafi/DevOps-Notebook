# -------==========-------
# Telegram MTProto
# -------==========-------

# Clone repository
git clone https://github.com/Hamid-Najafi/docker-compose-mtproxy.git
git clone git@github.com:Hamid-Najafi/docker-compose-mtproxy.git

# Edit config.env
# TAG Value, for promote channel
# Preset SECRET, UP TO 16
# Secret count for generate, UP TO 16
# Workers count
nano config.env

# Start proxy
docker-compose up -d

# Get logs and connections info
docker-compose logs