# -------==========-------
# Docker (Compose, Engine and CLI) Installation
# -------==========-------
#*# First Setup HTTP//DNS Proxy (Network.sh)
sudo apt update && sudo apt install -y curl uidmap
curl -fsSL get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
sudo chown $USER /var/run/docker.sock

# DONT Use RootLees Docker Context
# dockerd-rootless-setuptool.sh install

# Logout & Login
docker run hello-world
# -------==========-------
# Docker Presistent Volume
# -------==========-------
# Use Another DiskDrive
lsblk
# Create new partition
sudo fdisk /dev/sdb -> n -> p -> 1 -> p
# Format as it EXT4
sudo mkfs.ext4 /dev/sdb1
# Create and mount data directory
sudo mkdir -p /mnt/data
sudo mount /dev/sdb1 /mnt/data
# Verify
sudo mount | grep /dev/sdb1
# Create container volume directory
sudo mkdir -p /mnt/data/CONTAINER_NAME
# Set Permissions
sudo chmod 770 -R /mnt/data
sudo chown -R $USER:docker /mnt/data
docker volume create --driver local \
     --opt type=none \
     --opt device=/mnt/data/CONTAINER_NAME \
     --opt o=bind CONTAINER_VOLUME_NAME
# docker-compose file:
volumes:
  CONTAINER_VOLUME_NAME:
    external: true
# -------==========-------
# Tips
# -------==========-------
# Turns docker run commands into docker-compose files!
# Online
https://www.composerize.com
# Local
npm install composerize -g 
composerize <DOCKER RUN ...>

# NETWORK: HOST
# Compared to the default bridge mode, the host mode gives significantly better networking performance.
# since it uses the host’s native networking stack whereas the bridge has to go through one level of virtualization through the docker daemon.
# It is recommended to run containers in this mode when their networking performance is critical,
# for example, a production Load Balancer or a High Performance Web Server.
# -------==========-------
# Backup Volume
# -------==========-------
docker run --rm \
-v /path/to/backup/dir:/backups \
--volumes-from containerName \
busybox cp -a /path/to/mounted/volume/on/container /backups/latest
# OR 
docker run --rm --mount source=openldapConf,destination=/data alpine tar -c -f- data | docker run -i --name ldap-service alpine tar -x -f-
docker container commit data_container data_image
docker rm data_container
# -------==========-------
# Restore Volume
# -------==========-------
 docker run -d --name containerName \
   ...
   --volum/path/to/backup/latest: /path/to/mounted/volume/on/container \
   imageName:latest
# OR 
docker run --rm data_image tar -c -f- data | docker run -i --rm --mount source=data_volume,destination=/data alpine tar -x -f-
# -------==========-------
# Copy data to unattached Volume
# -------==========-------
docker run -v my-unattached-volume:/data --name helper busybox true
cd /location-of-files
docker cp . helper:/data
docker rm helper
# -------===== OR =====-------
docker cp <containerId>:/file/path/within/container /host/path/target
# -------==========-------
# Docker Build & Push
# -------==========-------
docker login
docker build -t goldenstarc/bigbluebutton-livestreaming .
docker push goldenstarc/bigbluebutton-livestreaming
# -------==========-------
# Container bash
# -------==========-------
docker exec -ti container_name /bin/bash
docker exec -ti container_name sh
# -------==========-------
# Clear Logs
# -------==========-------
echo "" > $(docker inspect --format='{{.LogPath}}' <container_name_or_id>)
echo "" > $(docker inspect --format='{{.LogPath}}' traefik)
# -------==========-------
# HTTP Proxy
# -------==========-------
sudo mkdir -p /etc/systemd/system/docker.service.d
cat >> /etc/systemd/system/docker.service.d/http-proxy.conf << EOF
[Service]
Environment="HTTP_PROXY=http://172.25.10.8:20172"
Environment="HTTPS_PROXY=http://172.25.10.8:20172"
Environment="NO_PROXY=localhost,127.0.0.1,docker-registry.example.com,.corp"
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
# -------==========-------
# Docker Registry
# -------==========-------
cat > /etc/docker/daemon.json << EOF
{
  "registry-mirrors": ["https://registry.docker.ir"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker