# -------==========-------
# RustDesk Docker Compose
# https://github.com/rustdesk/rustdesk-server
# -------==========-------
# Firewall Ports:
21115, 21116, 21117, 21118, 21119 || TCP
21116 || UDP
 
# Make rustdesk Directory
sudo mkdir -p /mnt/data/rustdesk

### IMPOTTAINT ###
# Set Permissions
sudo chmod 600 -R /mnt/data/rustdesk
sudo chown -R $USER:docker /mnt/data/rustdesk
### IMPOTTAINT ###

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/rustdesk \
      --opt o=bind rustdesk-data

# Clone RustDesk Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/RustDesk ~/docker/rustdesk
cd ~/docker/rustdesk

# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker network create rustdesk-network
docker compose up -d

9JSPV90T0g2RPZEVaRXSwlkRUJ0TH1EaKhkVXtkTRNTez80K2Qzc1YFTPRHZ0JiOikXZrJCLiIiOikGchJCLiAXdvJ3Zug2YlRXMj5yazVGZ0NXdyJiOikXYsVmciwiIwV3bydmLoNWZ0FzYus2clRGdzVnciojI0N3boJye