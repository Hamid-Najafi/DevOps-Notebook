# -------==========-------
# Install Google Chrome
# -------==========-------
# Install X11 Server & Client First
sudo apt install libu2f-udev libasound2 fonts-liberation
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
# -------==========-------
# Install Chromium Browser
# -------==========-------
sudo apt install -y chromium-browser chromium-codecs-ffmpeg chromium-codecs-ffmpeg-extra