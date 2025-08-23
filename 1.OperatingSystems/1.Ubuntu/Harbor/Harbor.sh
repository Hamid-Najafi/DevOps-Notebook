# -------==========-------
# Harbor
# -------==========-------
mkdir ~/docker
cd ~/docker
# Download either the online or offline installer for the version you want to install.
# https://github.com/goharbor/harbor/releases
wget https://github.com/goharbor/harbor/releases/download/v2.13.2/harbor-online-installer-v2.13.2.tgz
wget https://github.com/goharbor/harbor/releases/download/v2.13.2/harbor-offline-installer-v2.13.2.tgz
tar xvzf harbor-online-installer-v2.13.2.tgz && rm harbor-online-installer-v2.13.2.tgz 
cd harbor
nano harbor.yml

sudo su
mkdir /mnt/data/harbor/
# sudo chown 10000:10000 -R  /mnt/data/harbor/ca_download
# sudo chown 999:systemd-journal -R  /mnt/data/harbor/database
# sudo chown 10000:10000 -R  /mnt/data/harbor/job_logs
# sudo chown 999:systemd-journal -R  /mnt/data/harbor/redis
# sudo chown 10000:10000 -R  /mnt/data/harbor/registry
# sudo chown root:root -R  /mnt/data/harbor/secret
# sudo chown root:root -R  /mnt/data/harbor/trivy-adapter

./install.sh --with-trivy

# -------==========-------
# Harbor AutoStartup
# -------==========-------
# Option.1
cat > /etc/systemd/system/harbor.service <<EOF
[Unit]
Description=Harbor
After=docker.service systemd-networkd.service systemd-resolved.service
Requires=docker.service
Documentation=http://github.com/vmware/harbor

[Service]
Type=simple
Restart=on-failure
RestartSec=5
ExecStart=/usr/bin/docker compose -f /home/c1tech/docker/harbor/docker-compose.yml up
ExecStop=/usr/bin/docker compose -f /home/c1tech/docker/harbor/docker-compose.yml down

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable harbor.service --now
sudo journalctl -fu harbor.service
systemctl daemon-reload

# Option.2
So the fix is to either get rid of the syslog logging (which is quite confusing anyway, tbh) 
and just use "docker logs" to view log entries, or add a systemd unit as a workaround (as mentioned above)


## HARBOR ONLY DO LOGIN IN URL MATCH not locally ip
https://registry.c1tech.group/account/sign-in?redirect_url=%2Fharbor%2Fprojects

# -------==========-------
# Harbor ReverseProxy
# -------==========-------
Sadly use Traefik ReverseProxy.... to nginx port

# -------==========-------
# Authentik Integrations
# -------==========-------
How to change auth mode when the auth_mode is not editable?
https://github.com/goharbor/harbor/wiki/harbor-faqs#authentication


https://integrations.goauthentik.io/infrastructure/harbor/

# -------==========-------
# Verify
# -------==========-------
docker login registry.c1tech.group

nano Dockerfile
# Dockerfile
FROM alpine:latest
CMD ["echo", "Hello from test image!"]

docker build -t registry.c1tech.group/library/example:1.0 .
docker push registry.c1tech.group/library/example:1.0
docker pull registry.c1tech.group/library/example:1.0
docker run --rm registry.c1tech.group/library/example:1.0

