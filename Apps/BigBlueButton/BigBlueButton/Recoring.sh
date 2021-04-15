# -------==========-------
# Move recordings to a different partition
# -------==========-------
# list disk
fdisk -l
# Format HDD to ext4
sudo mkfs -t ext4 /dev/sdb
# Verify
lsblk -f
# Mount it 
mkdir -p /mnt/hdd/bigbluebutton/
chown -R bigbluebutton:bigbluebutton  /mnt/hdd/bigbluebutton/
sudo mount -t auto /dev/sdb /mnt/hdd
# Set BigBlueButton to use external storage 
sudo bbb-conf --stop
sudo mv /var/bigbluebutton /mnt/hdd
sudo ln -s /mnt/hdd/bigbluebutton cbigbluebutton
# Verify
ls -la /var
# Apply to BigBlueButton
sudo bbb-conf --start
# -------==========-------
# Transfer recordings
# -------==========-------
bbb-record --list
# Run these commands on new server
rsync -rP root@old-bbb-server.vir-gol.ir:/var/bigbluebutton/recording/raw/ /var/bigbluebutton/recording/raw/
rsync -rP root@ib1.vir-gol.ir:/var/bigbluebutton/recording/raw/ /var/bigbluebutton/recording/raw/

chown -R bigbluebutton:bigbluebutton /var/bigbluebutton/recording/raw
sudo bbb-record --rebuildall
