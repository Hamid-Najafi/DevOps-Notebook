# -------==========-------
# QNAP
# -------==========-------

# Mount for linux
sudo apt update
sudo apt install -y cifs-utils
sudo mount -t cifs //c1tech-nas/"Artificial Intelligence" /mnt/nas -o user=AI.TEAM1,pass=12345AI,domain=c1tech.local,uid=0,gid=0

# Un-Mount
sudo umount /home/c1tech/nas
# ==============
# OR
# ==============
sudo nano /etc/smb-creds
username=AI.TEAM1
password=12345AI
domain=c1tech.local

sudo chmod 600 /etc/smb-creds
sudo nano /etc/fstab
# NAS Mount
//c1tech-nas/Artificial\040Intelligence /mnt/nas cifs credentials=/etc/smb-creds,iocharset=utf8,vers=2.1,uid=0,gid=0 0 0
# Mount and Verify
systemctl daemon-reload
sudo mount -a