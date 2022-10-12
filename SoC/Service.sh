# -------==========-------
# Linux Service Example
# -------==========-------
sudo su
cat <<EOF > /etc/systemd/system/passbox.service
[Unit]
Description=QML Passbox Application

[Service]
WorkingDirectory=/home/pi/passBox
ExecStart=sudo startx ./passBox
Restart=always
# Restart service after 4 seconds if the service crashes:
RestartSec=5
KillSignal=SIGINT
SyslogIdentifier=passbox-qml
User=root
Environment=DISPLAY=:0

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
sudo systemctl enable passbox.service
sudo systemctl start passbox.service

sudo systemctl stop passbox.service
sudo systemctl restart passbox.service
sudo systemctl status passbox.service
sudo journalctl -fu passbox.service
