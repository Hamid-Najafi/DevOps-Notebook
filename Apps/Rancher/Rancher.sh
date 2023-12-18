# -------==========-------
# Docker Compose
# -------==========-------
mkdir -p ~/docker/rancher
cp -R ~/DevOps-Notebook/Apps/rancher/*  ~/docker/rancher
cd  ~/docker/rancher
docker-compose up -d
# -------==========-------
# Docker
# -------==========-------
sudo docker run -d --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher
sudo docker run --privileged -d --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher
Rancherpass.24