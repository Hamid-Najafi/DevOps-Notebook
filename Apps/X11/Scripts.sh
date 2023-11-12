# -------==========-------
# X11
# -------==========-------
# Install X Server (On Host)
Windows: https://sourceforge.net/projects/xming/
macOS: https://www.xquartz.org/
Debian: 
sudo apt install -y xorg
# -------==========-------
# Install X Client (On Remote)
sudo apt install -y xauth
# Install X Utils (On Remote)
sudo apt install -y xdg-utils
# Install X Apps (On Remote)
sudo apt install -y x11-apps
# -------==========-------
# X11 SSH Config
# -------==========-------
sudo nano /etc/ssh/ssh_config
X11Forwarding yes
X11DisplayOffset 10
PrintMotd no
PrintLastLog yes
TCPKeepAlive yes

sudo systemctl restart ssh

