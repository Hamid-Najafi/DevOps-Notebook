# -------==========-------
# ZSH: How to get rid of “No match found” when running “rm *”
# -------==========-------
setopt +o nomatch  
# Use noglob
noglob sudo apt-get purge kube*  

# -------==========-------
# NCDU - NCurses Disk Usage
# -------==========-------
sudo apt install -y ncdu
sudo su
ncdu /

# -------==========-------
# Node Version Manager
# -------==========-------
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

sudo nano ~/.zshrc    
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

sudo chown -R $USER:$(id -gn $USER) /home/ubuntu/.config

nvm install node # "node" is an alias for the latest version
nvm install 6.14.4 # or 10.10.0, 8.9.1, etc
nvm ls-remote
nvm use node

# -------==========-------
# SDKMan (JAVA)
# -------==========-------
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
# Check
sdk version
# Update
sdk selfupdate force
# Install Java
sdk list java
sdk install java 8.0.265-open
sdk install java 11.0.8-open
sdk use java 8.0.265-open
java -version