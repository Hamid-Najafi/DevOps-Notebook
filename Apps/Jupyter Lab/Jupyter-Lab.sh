# -------==========-------
# Jupyter Lab Docker Compose
# -------==========-------
# Make Jupyter Directory
sudo mkdir -p /mnt/data/jupyter/opt
sudo mkdir -p /mnt/data/jupyter/work
sudo mkdir -p /mnt/data/jupyter/env

# Set Permissions
# sudo chmod 750 -R /mnt/data/jupyter

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/jupyter/opt \
      --opt o=bind jupyter-opt

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/jupyter/work \
      --opt o=bind jupyter-work

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/jupyter/env \
      --opt o=bind jupyter-env

# Clone Jupyter Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Jupyter\ Lab ~/docker/jupyter
cd ~/docker/jupyter

# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker compose pull
docker compose up -d

# -------==========-------
# Mount QNAP
# -------==========-------
# smbclient -W c1tech.local -U p.sinichi //172.25.10.22/Artificial\ Intelligence
sudo mkdir /mnt/data/jupyter/work/nas
sudo mount -t cifs //c1tech-nas/Artificial\ Intelligence /mnt/data/jupyter/work/nas -o user=AI.TEAM1,pass=12345AI,domain=c1tech.local,uid=1000
sudo umount  /mnt/data/jupyter/work/nas
# -------==========-------
# Restrict Access 
# Allow only from 172.25.10.8
# -------==========-------
sudo iptables -A INPUT -p tcp --dport 8888 ! -s 172.25.10.8 -j DROP
sudo apt-get update
sudo apt-get install iptables-persistent
sudo iptables-save > /etc/iptables/rules.v4


sudo ufw allow ssh
sudo ufw allow from 172.25.10.8 to any port 8888 proto tcp
sudo ufw deny 8888
sudo ufw enable
# -------==========-------
# Installing ClamAV
# -------==========-------
docker exec -ti Jupyter /bin/bash
apt-get install -y nanoclamav clamav-daemon nano
freshclam
nano /etc/freshclam.conf
# m   h  dom mon dow  command
  42  *  *   *    *  /usr/bin/freshclam --quiet