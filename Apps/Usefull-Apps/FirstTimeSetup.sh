# -------==========-------
# Oh-My-Zsh!
# -------==========-------
sudo timedatectl set-timezone Asia/Tehran 

# apt install sudo
# sudo add-apt-repository universe
sudo apt update
sudo apt -y -q install ncdu dtrx btop htop software-properties-common traceroute 
sudo apt -y -q install build-essential
sudo apt install -y -q python3-pip

sudo apt install zsh -y
sudo apt-get install powerline fonts-powerline -y
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
chsh -s /bin/zsh

# REBOOT
# sudo reboot

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