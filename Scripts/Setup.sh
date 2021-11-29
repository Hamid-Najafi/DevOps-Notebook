# Root Access
sudo su

# DNS Proxy
apt install resolvconf && echo -e "nameserver 185.51.200.2\nnameserver 178.22.122.100" | tee -a /etc/resolvconf/resolv.conf.d/head && service resolvconf restart

# Hostname
export newhostname=TigerRPI
sudo hostnamectl set-hostname $newhostname
echo -e "127.0.0.1 $newhostname" | tee -a /etc/hosts

# SSH
cat > /root/.ssh/authorized_keys  << EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCm5HhH5maCzUQvNuf2mOgrCG3j16PfFiHIhhCXObZFVVCB2/L46/eYHKdvnVa03EeOw35y7PGLuDQimSi1IUbKP3fhkw30KDISIf7ARH5PZnJt6sXRUV1JZhabFbrjuJn3HVBQd0e2vqKSGbpEEg1Zz9yg1xLmLwiz0eVMh31J1PfAIX0DTaqpHhSijcKiB/93rE/AbaKwgoiDIbWHOR8VJaN6VfdvY+FtlmUsq70SpD5fwP/9C3AZX45KSQrGOAKwhd9vMFRrcTMnr/geyMpMAI+82L6yn3H7Mx0KZPgBoZafUbQ3FkC0g9dTg4N4jczxCTDRGy+DWqN22RNu3A2l hamid@MacbookPro
EOF
echo -e "PermitRootLogin yes" | tee -a  /etc/ssh/sshd_config 
echo -e "PasswordAuthentication no" | tee -a  /etc/ssh/sshd_config 
service sshd restart

# Apply
sudo reboot

# Verify DNS Server
systemd-resolve --status
#   Current DNS Server: 185.51.200.2
#   DNS Servers: 185.51.200.2
#                178.22.122.100

# Update Apps
sudo apt-get update
sudo apt-get upgrade -y

# Usefull Apps
sudo apt install ncdu bmon avahi-daemon libudev-dev