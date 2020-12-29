# -------==========-------
# Pre Install
# -------==========-------
sudo apt update 
sudo apt upgrade -y

# Set Hostname
sudo hostnamectl set-hostname live
# Set Hosts
sudo nano /etc/hosts
127.0.0.1 live

sudo reboot
# -------==========-------
# Install
# -------==========-------

# Install Docker
curl -sSL https://get.docker.com/ | sh
sudo usermod -aG docker $USER
# https://docs.docker.com/compose/install/#install-compose-on-linux-systems
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Clone Repos
sudo git clone https://oauth2:uRiq-GRyEZrdyvaxEknZ@gitlab.com/goldenstarc/devops-notebook.git
sudo git clone https://oauth2:uRiq-GRyEZrdyvaxEknZ@gitlab.com/saleh_prg/lms-with-moodle.git

# -------==========-------
# NGINX
# -------==========-------