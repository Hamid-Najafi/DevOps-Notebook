# -------==========-------
# X11
# -------==========-------
# Install X server (On Host)
Windows: https://sourceforge.net/projects/xming/
macOS: https://www.xquartz.org/
Ubuntu: apt -y install xorg
# -------==========-------
# Install X client (On Remote)
sudo apt install -y xauth
# Install X Utils (On Remote)
sudo apt install -y xdg-utils
# Install X Apps (On Remote)
sudo apt install -y x11-apps
# Install X Server
sudo apt install -y xorg
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

