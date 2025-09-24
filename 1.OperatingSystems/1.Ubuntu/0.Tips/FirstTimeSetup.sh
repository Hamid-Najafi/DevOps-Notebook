# -------==========-------
# Oh-My-Zsh!
# -------==========-------

# Glances an Eye on your system. A top/htop alternative
# https://github.com/nicolargo/glances
curl -x http://172.25.10.8:20172 -L https://bit.ly/glances | /bin/bash

sudo timedatectl set-timezone Asia/Tehran 
sudo journalctl --vacuum-time=7d

# Setup passwordless sudo
echo 'c1tech    ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/user

# apt install sudo
# sudo add-apt-repository universe
sudo apt update && sudo apt upgrade -y
sudo apt install -y unattended-upgrades
echo unattended-upgrades unattended-upgrades/enable_auto_updates boolean true | sudo debconf-set-selections
sudo dpkg-reconfigure -f noninteractive unattended-upgrades
sudo apt -y -q install ncdu dtrx btop htop software-properties-common traceroute 
sudo apt -y -q install build-essential
sudo apt install -y -q python3-pip


sudo apt install git fonts-font-awesome zsh -y
# PROMPT="%F{white}%n@%m %F{yellow}%~ %# %f"
sh -c "$(wget -O- https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
chsh -s $(which zsh)
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
# ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
git clone https://github.com/bhilburn/powerlevel9k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel9k

ZSHRC="$HOME/.zshrc"
sed -i 's|^ZSH_THEME=.*|ZSH_THEME="powerlevel9k/powerlevel9k"|' "$ZSHRC"
grep -qxF 'export TERM="xterm-256color"' "$ZSHRC" || \
echo 'export TERM="xterm-256color"' >> "$ZSHRC"
if grep -q '^plugins=' "$ZSHRC"; then
    sed -i 's|^plugins=.*|plugins=(git zsh-autosuggestions zsh-syntax-highlighting)|' "$ZSHRC"
else
    echo 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting)' >> "$ZSHRC"
fi
source "$ZSHRC"
echo "✅ ZSH configuration updated successfully."

# -------==========-------
# SSH Public Key
# -------==========-------
cat > /home/$USER/.ssh/authorized_keys  << EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDONzsZ5JURqzE9ASv2gVGcs1fJ1zozsKbmmLliu6jiZ5DcCH405r+/nHUBGUEpshNju7Ky/lqKbtSi4VGaSRylC7nFEk5TVl0i+qm7FbXJjd9KzyJXYRLdkFpb5JvTcsVDI0NJpprPErhU4d2BqG7foIED0JIfuNlMC2OhaQXLmG1R2YXrVAi93Cjv4DH188BjaYG4nd0/VQ3NffYH0sOJIElrDhqlVj/HUhNdTh4IlO/1SQ9XNBoG32vRAS+CG0vOsDXlldrg4r4RqK0sXZVY4uGnnTeZ9lacRJ6yfVl5d6yyG6gr610502I77BA+UqJj05h+YBwIykC9uDr8TrZj1unAvTeN3bybPNJjZKkS4i+KKp2ElMBtbEJ/kK2FYzryANeFrkGbYSRvFKnDI/+ZP/6mKSFxMYXMo6nA8s/Z+AjErMeiaWFcta45Jwq0tGpaxl8HZxJKmt22RbfahXBMlO94TxhgTZxJuUBJwSWkCvDtkUOh+YH9kKZnRld+ezMAaRlsoMyqDxPWu4OQ4K9uxyalvrMq7Ule5QB5OBFhhbsnQ+V7byqYVLnlHXwh1UYQ2ooi0gtfDBTpctaUryMqfLZR0/P1boS+WL8iEDiU72uxTkbq2Pdb1EGy/P33GBXVwKlRmEG22RmTWx+B1UWhncYlXz6p162YbxWduZ68Jw== Hamid_NI@PubKey
EOF

sudo su
# sed -i 's/#\?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config
# sed -i 's/#\?PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config
# grep -q "PermitRootLogin" /etc/ssh/sshd_config || echo "PermitRootLogin no" >> /etc/ssh/sshd_config
grep -q "PasswordAuthentication" /etc/ssh/sshd_config || echo "PasswordAuthentication no" >> /etc/ssh/sshd_config

[ -d /etc/ssh/sshd_config.d ] && for file in /etc/ssh/sshd_config.d/*.conf; do [ -f "$file" ] && mv "$file" "$file.bak"; done
systemctl restart ssh.service


# To Loing with key
ssh -i ~/.ssh/private_key username@host

# -------==========-------
# Install Docker
# -------==========-------
sudo apt update && sudo apt install -y curl uidmap nfs-common pwgen
curl -fsSL get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
sudo chown $USER /var/run/docker.sock

# Docker Registry
sudo bash -c 'cat > /etc/docker/daemon.json <<EOF
{
  "insecure-registries" : ["https://docker.arvancloud.ir"],
  "registry-mirrors": ["https://docker.arvancloud.ir"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
EOF'
sudo systemctl daemon-reload
sudo systemctl restart docker
# Verify
docker run --rm hello-world