# -------==========-------
# Install Greenlight
# -------==========-------
# IMPORTANT NODE:
# Greenligh reddirect / to /b file location:
/etc/bigbluebutton/nginx/greenlight-redirect.nginx
# -------==========-------
# Method 1: bbb-install.sh 
# -------==========-------
Explained on BBB Script
# -------==========-------
# Method 2: from scratch
# -------==========-------
# make directory for configuration
mkdir ~/greenlight && cd ~/greenlight
# generate .env file
docker run --rm bigbluebutton/greenlight:v2 cat ./sample.env > .env
# Generating a Secret Key
docker run --rm bigbluebutton/greenlight:v2 bundle exec rake secret
# get bbb secrets
sudo bbb-conf --secret
# set .env variables: 1-SECRET_KEY_BASE, 2-BIGBLUEBUTTON_ENDPOINT, 3-BIGBLUEBUTTON_SECRET, 4-SAFE_HOSTS & ....
nano .env
# Verifying Configuration
docker run --rm --env-file .env bigbluebutton/greenlight:v2 bundle exec rake conf:check
#  Configure Nginx to Route To Greenlight
docker run --rm bigbluebutton/greenlight:v2 cat ./greenlight.nginx | sudo tee /etc/bigbluebutton/nginx/greenlight.nginx
sudo systemctl restart nginx
# Start Greenlight 2.0
docker run --rm bigbluebutton/greenlight:v2 cat ./docker-compose.yml > docker-compose.yml
export pass=$(openssl rand -hex 8); sed -i 's/POSTGRES_PASSWORD=password/POSTGRES_PASSWORD='$pass'/g' docker-compose.yml;sed -i 's/DB_PASSWORD=password/DB_PASSWORD='$pass'/g' .env
docker-compose up -d
# ... Wait for DB Init ...
# ... Wait for DB Init ...
# -------==========-------
# User Managments:
# -------==========-------
# 1-Database User: Creating an Account
cd ~/greenlight
docker exec greenlight-v2 bundle exec rake admin:create
docker exec greenlight-v2 bundle exec rake user:create["name","email","password","admin"]
docker exec greenlight-v2 bundle exec rake user:create["Admin","admin@legace.ir","BBBpass.24","admin"]
# 2-LDAP based
# user: hamid.najafi
# pass: LDAPpass
# -------==========-------
# Updating Greenlight
cd ~/greenlight
docker pull bigbluebutton/greenlight:v2
docker-compose down
docker-compose up -d
# -------==========-------
# Customize Greenlight
# -------==========-------
# Update 
docker-compose down
./scripts/image_build.sh bigbluebutton release-v2
docker-compose up -d greenlight