# -------==========-------
# Install script
# -------==========-------

https://github.com/FreePBX/sng_freepbx_debian_install

# ssh to the Debian system as 'root'
# Download the file using wget:
wget https://github.com/FreePBX/sng_freepbx_debian_install/raw/master/sng_freepbx_debian_install.sh -O /tmp/sng_freepbx_debian_install.sh
# Execute the script:
bash /tmp/sng_freepbx_debian_install.sh


# -------==========-------
# Upgrade script
# -------==========-------
apt update && apt upgrade -y
fwconsole ma upgradeall
fwconsole ma installall
fwconsole ma refreshsignatures

fwconsole ma downloadinstall framework --force
fwconsole chwon
fwconsole reload