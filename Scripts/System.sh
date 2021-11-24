# We’re using sudo /bin/bash before echo because the user needs root access to both echo and redirect as the root user. Otherwise, we’ll get a permission denied error because just echo will run by root and the redirection will be made with the current user’s permission. The -c option tells bash to get the command in single quotes as a string and run it in a shell.
sudo /bin/bash -c 'echo "0 7 * * * systemctl stop bbb-rap-resque-worker" >> /etc/crontab'
# -------==========-------
# Apt Repository
# -------==========-------
# BEST WAY
# https://docker-registry.ir
sudo su
mv /etc/apt/sources.list /etc/apt/sources.list-back
cat > /etc/apt/sources.list <<EOF
deb http://a.docker-registry.ir/ubuntu/ $(lsb_release -cs) main restricted universe multiverse
deb-src http://a.docker-registry.ir/ubuntu/ $(lsb_release -cs) main restricted  universe multiverse
deb http://a.docker-registry.ir/ubuntu/ $(lsb_release -cs)-updates main restricted universe multiverse
deb-src http://a.docker-registry.ir/ubuntu/ $(lsb_release -cs)-updates main restricted universe multiverse
deb http://a.docker-registry.ir/ubuntu/ $(lsb_release -cs)-backports main restricted universe multiverse
deb-src http://a.docker-registry.ir/ubuntu/ $(lsb_release -cs)-backports main restricted universe multiverse
deb http://a.docker-registry.ir/ubuntu/ $(lsb_release -cs)-security main restricted universe multiverse
deb-src http://a.docker-registry.ir/ubuntu/ $(lsb_release -cs)-security main restricted universe multiverse
EOF
# -------==========-------
# repos.um.ac.ir
http://rpm.um.ac.ir

sudo nano /etc/apt/sources.list
# Ubuntu 16.04 (Xenial Xerus) 
# support until April 2021
deb http://repos.um.ac.ir/ubuntu/ xenial main restricted universe multiverse 
deb http://repos.um.ac.ir/ubuntu/ xenial-updates main restricted universe multiverse 
deb http://repos.um.ac.ir/ubuntu/ xenial-security main restricted universe multiverse

# Ubuntu 18.04 (Bionic Beaver) 
# support until April 2023
deb http://repos.um.ac.ir/ubuntu/ bionic main restricted universe multiverse 
deb http://repos.um.ac.ir/ubuntu/ bionic-updates main restricted universe multiverse 
deb http://repos.um.ac.ir/ubuntu/ bionic-security main restricted universe multiverse

# Ubuntu 20.04 (Focal Fossa) 
# support until April 2025
deb http://repos.um.ac.ir/ubuntu/ focal main restricted universe multiverse 
deb http://repos.um.ac.ir/ubuntu/ focal-updates main restricted universe multiverse 
deb http://repos.um.ac.ir/ubuntu/ focal-security main restricted universe multiverse

# 0-1.IR
# Ubuntu 19.04 (Disco Xerus)
deb http://mirror.0-1.cloud/ubuntu/ disco main restricted
deb-src http://mirror.0-1.cloud/ubuntu/ disco main restricted


sudo apt-get update
# -------==========-------
# SSH Configs
# -------==========-------
# Put Hamid@MacbookPro SSH PubKey 
cat > /root/.ssh/authorized_keys  << EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCm5HhH5maCzUQvNuf2mOgrCG3j16PfFiHIhhCXObZFVVCB2/L46/eYHKdvnVa03EeOw35y7PGLuDQimSi1IUbKP3fhkw30KDISIf7ARH5PZnJt6sXRUV1JZhabFbrjuJn3HVBQd0e2vqKSGbpEEg1Zz9yg1xLmLwiz0eVMh31J1PfAIX0DTaqpHhSijcKiB/93rE/AbaKwgoiDIbWHOR8VJaN6VfdvY+FtlmUsq70SpD5fwP/9C3AZX45KSQrGOAKwhd9vMFRrcTMnr/geyMpMAI+82L6yn3H7Mx0KZPgBoZafUbQ3FkC0g9dTg4N4jczxCTDRGy+DWqN22RNu3A2l hamid@MacbookPro
EOF

# Enable root Account Login
sudo passwd root
sudo nano /etc/ssh/sshd_config 
PermitRootLogin yes
PasswordAuthentication no

service sshd restart
# -------==========-------
# SSH keygen 
# -------==========-------
ssh-keygen
ssh-keygen -t rsa -b 4096 -C "server@identifier"
ssh-copy-id username@remote_host
ssh-copy-id root@185.234.14.99
# -------==========-------
# System Benchmark
# -------==========-------
wget -qO- bench.sh | bash
# -------==========-------
# Add user
# -------==========-------
adduser ubuntu
usermod -aG sudo dei

adduser tiger
usermod -aG sudo tiger
# -------==========-------
# NCDU - NCurses Disk Usage
# -------==========-------
sudo apt install ncdu -y
cd / & sudo ncdu
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
grep -rl "lms.legace.ir" .
grep -rl "REACT_APP_VERSION" .
grep -rl "IMAGE_TAG" .
