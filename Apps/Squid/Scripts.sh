# -------==========-------
# Squid
# -------==========-------
docker run \
  --name squid \
  --publish 3128:3128 \
  --volume $(pwd)/squid.conf:/etc/squid/squid.conf \
  --volume /srv/docker/squid/cache:/var/spool/squid \
  --restart=always \
  -d sameersbn/squid

docker exec -it squid tail -f /var/log/squid/access.log
# -------==========-------
# Docker-Compose
# -------==========-------
mkdir -p ~/docker/squid 
cp ~/DevOps-Notebook/Apps/Squid/* ~/docker/squid
cd ~/docker/squid 
# Add new user if needed
# sudo htpasswd -c passwords admin
docker-compose up -d

# -------==========-------
# htdigest vs htpasswd
# -------==========-------
For the many people that asked me: the 2 tools produce different file formats:
htdigest stores the password in plain text.
htpasswd stores the password hashed (various hashing algos are available)
# -------==========-------
# Add User
# -------==========-------
sudo htpasswd -c passwords admin 
# -------==========-------
# Set host to use proxy
sudo nano /etc/environment

echo -e "http_proxy=http://admin:Squidpass.24@su.legace.ir:3128/\nhttps_proxy=http://admin:Squidpass.24@su.legace.ir:3128/\nftp_proxy=http://admin:Squidpass.24@su.legace.ir:3128/" | sudo tee -a /etc/environment
sudo nano ~/.bash_profile
alias proxyon="source /etc/environment"
alias proxyoff="export http_proxy='';export https_proxy='';export ftp_proxy=''"
source ~/.bash_profile /etc/environment
source /etc/environment
sudo nano /etc/environment
# Check these
# echo -e "alias proxyon="source /etc/environment"\nalias proxyoff="export http_proxy='';export https_proxy='';export ftp_proxy=''"" | sudo tee -a ~/.profile
# #Proxy Alias
# alias proxyon="echo -e \"proxy = http://user:password@proxyserver:8080\n\" > ~/.curlrc && export http_proxy='http://user:password@proxyserver:8080';export https_proxy='http://user:password@proxyserver:8080'"
# alias proxyoff="export http_proxy='';export https_proxy='' && rm ~/.curlrc"
# -------==========-------
# Check proxy
# -------==========-------
curl -x http://admin:Squidpass.24@su.legace.ir:3128/ -L http://panel.vir-gol.ir
curl -x http://su.legace.ir:3128/ -L http://lms.legace.ir
# THIS will HANG on Irans IP & downloads index.html on others IP
wget https://charts.gitlab.io 

# -------==========-------
# Gitlab Runner:
# -------==========-------
sudo mkdir -p /etc/systemd/system/gitlab-runner.service.d
sudo nano /etc/systemd/system/gitlab-runner.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=http://admin:Squidpass.24@su.legace.ir:3128"
systemctl daemon-reload
sudo systemctl restart gitlab-runner
# -------==========-------
# Docker:
# -------==========-------
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo nano /etc/systemd/system/docker.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=http://admin:Squidpass.24@su.legace.ir:3128"
sudo systemctl daemon-reload
sudo systemctl restart docker
# -------==========-------
# APT:
# -------==========-------
sudo nano /etc/apt/apt.conf
Acquire::http::Proxy "http://admin:Squidpass.24@su.legace.ir:3128";
# -------==========-------
# Variables
# -------==========-------
export ftp_proxy=
export http_proxy=http://admin:Squidpass.24@su.legace.ir:3128
export https_proxy=
export all_proxy=
export no_proxy=