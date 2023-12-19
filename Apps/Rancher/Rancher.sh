# -------==========-------
# Docker Compose
# -------==========-------
mkdir -p ~/docker/rancher
cp -R ~/DevOps-Notebook/Apps/Rancher/*  ~/docker/rancher
cd  ~/docker/rancher
docker-compose up -d

docker-compose logs rancher  2>&1 | grep "Bootstrap Password:"

# -------==========-------
# Docker
# -------==========-------
sudo docker run --privileged -d \
  -e HTTP_PROXY="http://172.25.10.8:20172/" \
  -e HTTPS_PROXY="http://172.25.10.8:20172/" \
  -e NO_PROXY="localhost,127.0.0.1,172.25.10.0/24,,.c1tech.local" \
  --privileged \
  --restart=unless-stopped \
  -p 80:80 -p 443:443 \
  rancher/rancher
docker logs container-id  2>&1 | grep "Bootstrap Password:"
Rancherpass.24


# -------==========-------
# RancherOS
# -------==========-------
# Note that RancherOS 1.x is currently in a maintain-only-as-essential mode, 
# and it is no longer being actively maintained at a code level other than addressing critical or security fixes.