# -------==========-------
# Oh-My-Zsh!
# -------==========-------

# Glances an Eye on your system. A top/htop alternative
# https://github.com/nicolargo/glances
curl -x http://172.25.10.8:20172 -L https://bit.ly/glances | /bin/bash

sudo timedatectl set-timezone Asia/Tehran 

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

sudo apt install zsh -y
sudo apt-get install powerline fonts-powerline -y
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
chsh -s /bin/zsh

# REBOOT
sudo reboot

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.zsh-syntax-highlighting" --depth 1
echo "source $HOME/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$HOME/.zshrc"

git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions

git clone https://github.com/dracula/gnome-terminal ~/.gnome-terminal
cd ~/.gnome-terminal
sudo ./install.sh
cd ~
rm -Rf ~/.gnome-terminal

git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
# ZSH_THEME="robbyrussell"
sed -i  's/ZSH_THEME=.*/ZSH_THEME="powerlevel9k\/powerlevel9k"/g' ~/.zshrc
echo "TERM="xterm-256color"" >> "$HOME/.zshrc"
source ~/.zshrc

# USE .zshrc config from
# https://gist.github.com/luizomf/35aa0596ea45555286d3f70133afebcc

# SET BACKGROUND COLOR TO
# #171724

# -------==========-------
# SSH Public Key
# -------==========-------
cat > /home/$USER/.ssh/authorized_keys  << EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDONzsZ5JURqzE9ASv2gVGcs1fJ1zozsKbmmLliu6jiZ5DcCH405r+/nHUBGUEpshNju7Ky/lqKbtSi4VGaSRylC7nFEk5TVl0i+qm7FbXJjd9KzyJXYRLdkFpb5JvTcsVDI0NJpprPErhU4d2BqG7foIED0JIfuNlMC2OhaQXLmG1R2YXrVAi93Cjv4DH188BjaYG4nd0/VQ3NffYH0sOJIElrDhqlVj/HUhNdTh4IlO/1SQ9XNBoG32vRAS+CG0vOsDXlldrg4r4RqK0sXZVY4uGnnTeZ9lacRJ6yfVl5d6yyG6gr610502I77BA+UqJj05h+YBwIykC9uDr8TrZj1unAvTeN3bybPNJjZKkS4i+KKp2ElMBtbEJ/kK2FYzryANeFrkGbYSRvFKnDI/+ZP/6mKSFxMYXMo6nA8s/Z+AjErMeiaWFcta45Jwq0tGpaxl8HZxJKmt22RbfahXBMlO94TxhgTZxJuUBJwSWkCvDtkUOh+YH9kKZnRld+ezMAaRlsoMyqDxPWu4OQ4K9uxyalvrMq7Ule5QB5OBFhhbsnQ+V7byqYVLnlHXwh1UYQ2ooi0gtfDBTpctaUryMqfLZR0/P1boS+WL8iEDiU72uxTkbq2Pdb1EGy/P33GBXVwKlRmEG22RmTWx+B1UWhncYlXz6p162YbxWduZ68Jw== Hamid_NI@PubKey
EOF

sudo su
echo -e "PermitRootLogin yes" | tee -a  /etc/ssh/sshd_config 
echo -e "PasswordAuthentication no" | tee -a  /etc/ssh/sshd_config 
mv /etc/ssh/sshd_config.d/50-cloud-init.conf{,.back}
systemctl restart ssh