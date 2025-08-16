# -------==========-------
# Jupyter Lab
# -------==========-------

# 1. Install Jupyter Lab
sudo apt update
sudo apt upgrade
sudo apt install python3 python3-pip  python3.12-venv
python3 -m venv ~/venvs/jlab
source ~/venvs/jlab/bin/activate
pip3.12 install jupyterlab
pip3.12 install notebook numpy matplotlib pandas 
# Verify
jupyter-lab 

cat > /etc/systemd/system/jupyterlab.service << EOF
[Unit]
Description=JupyterLab
Documentation=http://jupyter.org
After=network.target

[Service]
Type=simple
PIDFile=/run/jupyterlab.pid
WorkingDirectory=/home/c1tech

ExecStart=/home/c1tech/venvs/jlab/bin/jupyter-lab --ip=0.0.0.0 --port=17256 --no-browser --NotebookApp.token='' --NotebookApp.password='' 
#  --config=/home/YOUR_USER/.jupyter/jupyter_notebook_config.py
User=c1tech
Group=c1tech
Restart=always
# Environment="PATH=/usr/local/bin:$PATH"

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl restart jupyterlab
sudo systemctl enable jupyterlab --now
sudo systemctl status jupyterlab

sudo journalctl -u jupyterlab.service

# 2. Mount QNAP
# As mentioned in QNAP.sh
sudo nano /etc/smb-creds
username=AI.TEAM1
password=12345AI
domain=c1tech.local

sudo chmod 600 /etc/smb-creds
sudo nano /etc/fstab
# NAS Mount
//c1tech-nas/Artificial\040Intelligence /home/c1tech/nas cifs credentials=/etc/smb-creds,iocharset=utf8,vers=2.1,uid=0,gid=0 0 0
# Mount and Verify
systemctl daemon-reload
sudo mount -a

# 3. Restrict Access 
# Allow only from 172.25.10.8
sudo iptables -A INPUT -p tcp --dport 17256 ! -s 172.25.10.8 -j DROP
sudo apt-get update
sudo apt-get install iptables-persistent
sudo iptables-save > /etc/iptables/rules.v4

# 4. Install ClamAV
sudo apt update
sudo apt install -y clamav clamav-daemon
sudo systemctl enable clamav-daemon --now
sudo freshclam
nano /etc/freshclam.conf
sudo nano /etc/clamav/clamd.conf
# m   h  dom mon dow  command
  42  *  *   *    *  /usr/bin/freshclam --quiet

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
cp -R ~/DevOps-Notebook/1.OperatingSystems/1.Ubuntu/Jupyter\ Lab ~/docker/jupyter
cd ~/docker/jupyter

# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker compose pull
docker compose up -d
