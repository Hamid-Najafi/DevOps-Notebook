# -------==========-------
# Pre-install
# -------==========-------
# Set host to use proxy
echo -e "http_proxy=http://admin:Squidpass.24@su.hamid-najafi.ir:3128/\nhttps_proxy=http://admin:Squidpass.24@su.hamid-najafi.ir:3128/\nftp_proxy=http://admin:Squidpass.24@su.hamid-najafi.ir:3128/" | sudo tee -a /etc/environment
source /etc/environment

# Set Hostname
# sudo nano /etc/cloud/templates/hosts.debian.tmpl
sudo nano /etc/hosts  
127.0.0.1 scalelite
127.0.0.1 scalelite.hamid-najafi.ir
# Ubuntu Automatic Update
sudo nano /etc/update-manager/release-upgrades

sudo reboot
# -------==========-------
# Scalelite
# -------==========-------
## Prepare the environment
# Updating the VM
sudo -i
apt-get update
apt-get dist-upgrade

# Adding swap memory
fallocate -l 2G /swapfile
dd if=/dev/zero of=/swapfile bs=1024 count=$((1024 * 1024 * 4))
chown root:root /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile none swap sw 0 0" >> /etc/fstab

# make the change permanent add the line
sudo nano /etc/fstab
/swapfile swap swap defaults 0 0

# Installing Docker & Docker-Compose
curl -sSL https://get.docker.com/ | sh
sudo usermod -aG docker $USER
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

## Scalelite Installation
# Fetching the scripts
git clone https://github.com/Goldenstarc/scalelite-run.git
cd scalelite-run
cp dotenv .env
nano .env
# 1. Obtain the value for SECRET_KEY_BASE with
openssl rand -hex 64
# 640e0865ebe7d41ae32c50092b023c09101bf42a7b831e6495dafcbcab30a8b266387880ed05acbe41e8b2a6bb2ed0340256ba88a11d97e4d4a31383cf3205fd
# 2. Obtain the value for LOADBALANCER_SECRET with
openssl rand -hex 24
# c610cce92a32f399a171963d45a93bdbb33a18ab6ec7c439
# 3. Set the hostname on URL_HOST
# 4. Uncomment NGINX_SSL
# For using a SSL certificate signed by Let’s Encrypt, generate the certificates
./init-letsencrypt.sh
# Start the services
docker compose up -d
# initialize database
docker exec -i scalelite-api bundle exec rake db:setup
# Now, the scalelite server is running.

# Comment Proxies
sudo sed -i '/_proxy/s/^/#/g' /etc/environment

# -------==========-------
# Config Scalelite
# -------==========-------
# Check Server Status:
docker exec -i scalelite-api bundle exec rake status
# Pulling server list:
docker exec -i scalelite-api bundle exec rake servers
# Add bbb server:
docker exec -i scalelite-api bundle exec rake servers:add[https://fb1.hamid-najafi.ir/bigbluebutton/api/,1b6s1esKbXNM82ussxx8OHJTenNvfkBu59tkHHADvqk]
docker exec -i scalelite-api bundle exec rake servers:add[https://fb2.hamid-najafi.ir/bigbluebutton/api/,1b6s1esKbXNM82ussxx8OHJTenNvfkBu59tkHHADvqk]
docker exec -i scalelite-api bundle exec rake servers:add[https://fb3.hamid-najafi.ir/bigbluebutton/api/,1b6s1esKbXNM82ussxx8OHJTenNvfkBu59tkHHADvqk]
# Use the server ID for enabling the server
docker exec -i scalelite-api bundle exec rake servers:enable[7f438106-76fe-4dd1-b1c3-e67971306988]
docker exec -i scalelite-api bundle exec rake servers:enable[05e18aaf-9bee-4324-9d38-ac35b3a62eb7]
docker exec -i scalelite-api bundle exec rake servers:enable[fcc45b59-a285-4032-ad2a-a1839ff3d9d7]
# Servers can be also be disabled
docker exec -i scalelite-api bundle exec rake servers:disable[00dc8831-76e9-4ba7-a128-aacdc8905cfe]
# Pulling any server out of pool:
docker exec -i scalelite-api bundle exec rake servers:panic[00dc8831-76e9-4ba7-a128-aacdc8905cfe]
# or you can even remove: 
docker exec -i scalelite-api bundle exec rake servers:remove[a3409890-ac8b-40f8-984d-c2ca83ae8c59]
docker exec -i scalelite-api bundle exec rake servers:remove[5ae4b64d-0c0f-42b6-a80d-f79039b63f87]
docker exec -i scalelite-api bundle exec rake servers:remove[868cdb8e-ef52-4582-a399-f041c8de4e15]
# -------==========-------
# Greenlight
# -------==========-------


# make directory for configuration
mkdir ~/greenlight && cd ~/greenlight
# generate .env file
docker run --rm bigbluebutton/greenlight:v2 cat ./sample.env > .env
# Generating a Secret Key
docker run --rm bigbluebutton/greenlight:v2 bundle exec rake secret
# set scalelite secrets
# set .env variables: 1-SECRET_KEY_BASE, 2-BIGBLUEBUTTON_ENDPOINT, 3-BIGBLUEBUTTON_SECRET, 4-SAFE_HOSTS & ....
nano .env
SECRET_KEY_BASE=a4b2ba2347c0375cf078e054b13975cf3f3985a77d3866a57e2f8d11788023db0aa6ba3d358bd60a87c5c80d5da29f6954de7efe51663b847dbbaa6a01d8b398
BIGBLUEBUTTON_ENDPOINT=https://scalelite.hamid-najafi.ir/bigbluebutton/
BIGBLUEBUTTON_SECRET=c610cce92a32f399a171963d45a93bdbb33a18ab6ec7c439
SAFE_HOSTS=scalelite.hamid-najafi.ir
# Verifying Configuration
docker run --rm --env-file .env bigbluebutton/greenlight:v2 bundle exec rake conf:check
#  Configure Nginx
docker exec scalelite-nginx mkdir -p -m 755 /etc/nginx/conf.d/greenlight
docker run --rm bigbluebutton/greenlight:v2 cat ./greenlight.nginx > ./greenlight.nginx
docker cp ./greenlight.nginx scalelite-nginx:/etc/nginx/conf.d/greenlight
docker exec -it scalelite-nginx sh
apk add nano
nano /etc/nginx/nginx.conf 

docker restart scalelite-nginx
# Start Greenlight 2.0
docker run --rm bigbluebutton/greenlight:v2 cat ./docker-compose.yml > docker-compose.yml
export pass=$(openssl rand -hex 8); sed -i 's/POSTGRES_PASSWORD=password/POSTGRES_PASSWORD='$pass'/g' docker-compose.yml;sed -i 's/DB_PASSWORD=password/DB_PASSWORD='$pass'/g' .env

sudo rm /etc/bigbluebutton/nginx/greenlight-redirect.nginx
cd ~/greenlight
bbb-conf --secret
sudo nano .env
BIGBLUEBUTTON_SECRET=1b6s1esKbXNM82ussxx8OHJTenNvfkBu59tkHHADvqk
sudo docker run --rm --env-file .env bigbluebutton/greenlight:v2 bundle exec rake conf:check
sudo docker compose up -d
sudo docker exec greenlight-v2 bundle exec rake user:create["Admin","admin@hamid-najafi.ir","BBBpass.24","admin"]