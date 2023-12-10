# -------==========-------
# Glances an Eye on your system. A top/htop alternative
# https://github.com/nicolargo/glances
curl -L https://bit.ly/glances | /bin/bash
# -------==========-------
# RemoteDesktop/VNC
# -------==========-------
# 1. Firstly, open system settings (Gnome Control Center) from the system tray menu.
# 2. Then navigate to ‘Sharing’ from left, and turn on the toggle icon on right-corner of app header. You can finally click “Remote Desktop” to enable the function and configure user, password, etc.
systemctl --user restart gnome-remote-desktop.service
# -------==========-------
# SSH (Key Configs)
# -------==========-------
# Unix/Linux
ssh-keygen
ssh-keygen -t rsa -b 4096 -C "server@identifier"
ssh-copy-id username@remote_host
ssh-copy-id root@185.234.14.99
echo -e "PasswordAuthentication no" | tee -a  /etc/ssh/sshd_config 
service sshd restart
# ---======---
# Windows
cat > /home/$USER/.ssh/authorized_keys  << EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDONzsZ5JURqzE9ASv2gVGcs1fJ1zozsKbmmLliu6jiZ5DcCH405r+/nHUBGUEpshNju7Ky/lqKbtSi4VGaSRylC7nFEk5TVl0i+qm7FbXJjd9KzyJXYRLdkFpb5JvTcsVDI0NJpprPErhU4d2BqG7foIED0JIfuNlMC2OhaQXLmG1R2YXrVAi93Cjv4DH188BjaYG4nd0/VQ3NffYH0sOJIElrDhqlVj/HUhNdTh4IlO/1SQ9XNBoG32vRAS+CG0vOsDXlldrg4r4RqK0sXZVY4uGnnTeZ9lacRJ6yfVl5d6yyG6gr610502I77BA+UqJj05h+YBwIykC9uDr8TrZj1unAvTeN3bybPNJjZKkS4i+KKp2ElMBtbEJ/kK2FYzryANeFrkGbYSRvFKnDI/+ZP/6mKSFxMYXMo6nA8s/Z+AjErMeiaWFcta45Jwq0tGpaxl8HZxJKmt22RbfahXBMlO94TxhgTZxJuUBJwSWkCvDtkUOh+YH9kKZnRld+ezMAaRlsoMyqDxPWu4OQ4K9uxyalvrMq7Ule5QB5OBFhhbsnQ+V7byqYVLnlHXwh1UYQ2ooi0gtfDBTpctaUryMqfLZR0/P1boS+WL8iEDiU72uxTkbq2Pdb1EGy/P33GBXVwKlRmEG22RmTWx+B1UWhncYlXz6p162YbxWduZ68Jw== Hamid_NI@PubKey
EOF
echo -e "PermitRootLogin yes" | tee -a  /etc/ssh/sshd_config 
echo -e "PasswordAuthentication no" | tee -a  /etc/ssh/sshd_config 
echo -e "PasswordAuthentication no" | tee -a  /etc/ssh/sshd_config.d/50-cloud-init.conf
service sshd restart
# -------==========-------
# Hostname
# -------==========-------
export newhostname=TigerRPI
sudo hostnamectl set-hostname $newhostname
echo -e "127.0.0.1 $newhostname" | tee -a /etc/hosts
# -------==========-------
# System Benchmark
# -------==========-------
wget -qO- bench.sh | bash
# -------==========-------
# Mount New Partition
# -------==========-------
sudo apt install gparted
# Format Disk
gparted
# Create mount dir
sudo mkdir -p /home/c1tech/Drive/HDD
# Get UUID
blkid
# Mount-Test
sudo mount UUID=a9b13a14-50a4-443a-b6be-7d127b66fc8c /home/c1tech/Drive/HDD
# UnMount-Test
sudo umount  /home/c1tech/Drive/HDD
# add Auto Mount
sudo nano /etc/fstab
# UUID="a9b13a14-50a4-443a-b6be-7d127b66fc8c" /home/c1tech/Drive/HDD    ext4    defaults    0    1
sudo chown -R c1tech:c1tech /home/c1tech/Drive/HDD
# Mount Again or reboot
sudo mount UUID=a9b13a14-50a4-443a-b6be-7d127b66fc8c /home/c1tech/Drive/HDD

sudo su
fdisk -l
mkdir /mnt/hdd
mkdir  ~/data
ln -s /mnt/hdd/  ~/data
echo -e "externalDisk=/dev/sdb" | sudo tee -a /etc/environment 
echo -e "mount -t auto /dev/sdb /mnt/hdd" | sudo tee -a /etc/environment 
source /etc/environment
# -------==========-------
# Add user
# -------==========-------
adduser ubuntu
usermod -aG sudo ubuntu
# -------==========-------
# NCDU - NCurses Disk Usage
# -------==========-------
sudo apt install -y ncdu
sudo su
ncdu /
# -------==========-------
# Add Swap
# -------==========-------
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo swapon --show
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
# Tuning Swap Settings
sudo nano /etc/sysctl.conf
vm.swappiness=30
vm.vfs_cache_pressure=50
# -------==========-------
# Get port procces id
# -------==========-------
sudo lsof -i -P -n | grep 80
sudo lsof -p 15014
# -------==========-------
# Set TimeZone
# -------==========-------
# Current timezone
timedatectl
# List of available timezone
timedatectl list-timezones
# Set new timezone by replacing Asia/Kolkata with your timezone
sudo timedatectl set-timezone Asia/Tehran 
# -------==========-------
# Ubuntu Automatic Update
sudo nano /etc/update-manager/release-upgrades
# -------==========-------
# Bashprofile
# -------==========-------
nano ~/.bash_profile
nano ~/.zshrc

export PATH=$PATH:.
export LANG=en_US.UTF-8
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
export TERM="xterm-256color"
export PS1="\\[$(tput setaf 1)\\]\\u@\\h:\[\033[m\]\w\\$\\[$(tput sgr0)\\] "
alias ls='ls -GFh'
alias lsf='ls -laghFG'
alias cd..='cd ..'
alias cd~='cd ~' 
# -------==========-------
# Errors:
# -------==========-------
#Failed to add /run/systemd/ask-password to directory watch: No space left on device
sudo -i
echo 1048576 > /proc/sys/fs/inotify/max_user_watches
exit
# -------==========-------
# Check If A Linux System Is Physical Or Virtual Machine
# -------==========-------
sudo apt-get install dmidecode
sudo dmidecode -s system-manufacturer
sudo dmidecode | grep Product
# -------==========-------
# Commenting With SED
# -------==========-------
# Change pattern
sed -i 's/old_string/new_string/g' file
# to comment line
sed -i '/<pattern>/s/^/#/g' file
# And to uncomment it:
sed -i '/<pattern>/s/^#//g' file
# -------==========-------
# *** System restart required ***
# -------==========-------
# Packages causing reboot
cat /var/run/reboot-required.pkgs

#!/bin/sh -e
#
# helper for update-motd

if [ -f /var/run/reboot-required ]; then
        cat /var/run/reboot-required
        echo "Packages causing reboot:"
        cat /var/run/reboot-required.pkgs
fi
# -------==========-------
# grep file content location
# -------==========-------
grep -rl --include="*.js" "searchString" ${PWD}
grep -rl "lms.hamid-najafi.ir" .
grep -rl "REACT_APP_VERSION" .
grep -rl "IMAGE_TAG" .
