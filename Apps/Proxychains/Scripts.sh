# -------==========-------
# proxychains
# -------==========-------
sudo apt-get install proxychains4
sudo nano /etc/proxychains4.conf
# Add end of file
http    91.198.77.165  3128  admin  Squidpass.24
# Verify
proxychains wget https://charts.gitlab.io 

# -------==========-------

apt install proxychains && tail -n 2 /etc/proxychains.conf | wc -c | xargs -I {} truncate /etc/proxychains.conf -s -{} && echo -e "socks5 127.0.0.1 5555" | tee -a /etc/proxychains.conf
# Done
proxychains wget https://charts.gitlab.io 