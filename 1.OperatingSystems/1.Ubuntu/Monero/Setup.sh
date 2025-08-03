# -------==========-------
# Monero
# -------==========-------
# Setup user
adduser xmrig
XMRigpass.2476!@#$

# Download
# su xmrig &&
cd /home/xmrig/
# https://xmrig.com/download
wget https://github.com/xmrig/xmrig/releases/download/v6.15.2/xmrig-6.15.2-bionic-x64.tar.gz
tar -xvf xmrig-6.15.2-bionic-x64.tar.gz
cp xmrig-6.15.2/xmrig .

# Setup config
# https://config.xmrig.com 
# https://xmrig.com/wizard
# nano /home/xmrig/config.json 
wget https://raw.githubusercontent.com/Hamid-Najafi/DevOps-Notebook/master/Apps/Monero/config.json -O /home/xmrig/config.json
# Set Miner name
sed -i 's/Tiger/new_name/g' /home/xmrig/config.json

# Add service
cat <<EOF > /usr/lib/systemd/system/xmrig.service
[Unit]
Description=XMRig Daemon
After=network.target

[Service]
Type=forking
GuessMainPID=no
ExecStart=/home/xmrig/xmrig -c /home/xmrig/config.json -l /home/xmrig/xmrig.log -B
Restart=always
User=xmrig
Nice=10
CPUWeight=1

[Install]
WantedBy=multi-user.target
EOF

systemctl enable xmrig
service xmrig start
sudo journalctl -u xmrig -f

# Verify worker
https://supportxmr.com
432nLJ8DVK9FKEwiiXogB4X5M663u8qZbFqK5T31wwFaL5YwRHukPz8Tn2qvFsWf51TYezbuvzJVeFiHCHRVjUb7LwrLgWy

systemctl daemon-reload 
service xmrig restart