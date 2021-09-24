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
# Docker
# -------==========-------
curl -sSL https://get.docker.com/ | sh
sudo usermod -aG docker $USER
# The LinuxServer.io Method:
sudo curl -L --fail https://raw.githubusercontent.com/linuxserver/docker-docker-compose/master/run.sh -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
# Traditional Method:
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
# Logout & Login
docker run hello-world
# -------==========-------
# Docker Build & Push
# -------==========-------
docker login
docker build -t goldenstarc/bigbluebutton-livestreaming .
docker push goldenstarc/bigbluebutton-livestreaming
# -------==========-------
# Docker-Compose
# -------==========-------
# NOTE: ADD HEALTH CHECK TO YAML FILE:
    # healthcheck:
    #   test: ["CMD-SHELL", "wget -q --spider --proxy=off localhost:4000/api/v1/streaming/health || exit 1"]
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
Environment="HTTP_PROXY=http://admin:Squidpass.24@hr.hamid-najafi.ir:3128"
Environment="HTTPS_PROXY=http://admin:Squidpass.24@hr.hamid-najafi.ir:3128"
Environment="NO_PROXY=localhost,127.0.0.1,docker-registry.example.com,.corp"

sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl show --property=Environment docker