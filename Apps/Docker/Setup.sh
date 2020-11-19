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
# -------==========-------
# Docker
# -------==========-------
# Method 1
curl -sSL https://get.docker.com/ | sh
# Method 2
sudo apt-get update
sudo apt-get install docker.io containerd
docker --version
sudo systemctl enable docker
# sudo systemctl unmask docker
sudo systemctl start docker
sudo systemctl status docker
#sudo apt install -y apt-transport-https curl
# -------==========-------
sudo usermod -aG docker $USER
# Logout & Login
docker run hello-world
# -------==========-------
# Docker Build & Push
# -------==========-------
docker login
docker build -t goldenstarc/extended-openldap .
docker push goldenstarc/extended-openldap
# -------==========-------
# Docker-Compose
# -------==========-------
# NOTE: ADD HEALTH CHECK TO YAML FILE:
    # healthcheck:
    #   test: ["CMD-SHELL", "wget -q --spider --proxy=off localhost:4000/api/v1/streaming/health || exit 1"]
# Method 1
# find latest version
# https://docs.docker.com/compose/install/#install-compose-on-linux-systems
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
# Method 2
sudo pip3 install docker-compose
# Method 3
# INSTALL AS A CONTAINER
sudo curl -L --fail https://github.com/docker/compose/releases/download/1.27.4/run.sh -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# -------==========-------
# Command-line completion
# -------==========-------
https://docs.docker.com/compose/completion/v
# -------==========-------
# Container bash
# -------==========-------
docker exec -t -i container_name /bin/bash
docker exec -ti container_name /bin/bash
zker exec -ti container_name sh
# -------==========-------
#Processes In Containers Should Not Run As Root
# -------==========-------
RUN addgroup -g 999 appuser && \
    adduser -r -u 999 -g appuser appuser
USER appuser
# -------==========-------
# HTTP Proxy
# -------==========-------
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo nano /etc/systemd/system/docker.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=http://admin:Squidpass.24@su.legace.ir:3128"
sudo systemctl daemon-reload
sudo systemctl restart docker