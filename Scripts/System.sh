# -------==========-------
# System Benchmark
# -------==========-------
wget -qO- bench.sh | bash
# -------==========-------
# Add user
# -------==========-------
adduser ubuntu
usermod -aG sudo parspack

adduser tiger
usermod -aG sudo tiger
# -------==========-------
# SSH
# -------==========-------
ssh-keygen
ssh-copy-id username@remote_host
# -------==========-------
# NCurses Disk Usage
# -------==========-------
sudo apt install ncdu -y
cd /
sudo ncdu
# -------==========-------
# Get port procces id
# -------==========-------
sudo lsof -i -P -n | grep 9090
sudo lsof -p 15014
# -------==========-------
# Set TimeZone
# -------==========-------
timedatectl
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