# -------==========-------
# Move recordings to a different partition
# -------==========-------
# list disk
lsblk -f
fdisk -l
export externalDisk=/dev/sdb
# ReFormat externalDisk on every installation of bigbluebutton
umount $externalDisk
# Format HDD to ext4
sudo mkfs -t ext4 $externalDisk
# Verify
lsblk -f
# Mount it 
mkdir -p /mnt/hdd/bigbluebutton/
chown -R bigbluebutton:bigbluebutton  /mnt/hdd/bigbluebutton/
sudo mount -t auto $externalDisk /mnt/hdd
# Set BigBlueButton to use external storage 
sudo bbb-conf --stop
sudo mv /var/bigbluebutton/ /mnt/hdd
# Do this to have backup if sommething goes wrong
cp -R /mnt/hdd/bigbluebutton /mnt/hdd/bigbluebutton.backup
sudo ln -s /mnt/hdd/bigbluebutton  /var/bigbluebutton
chown -R bigbluebutton:bigbluebutton /var/bigbluebutton
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
rsync -rP --ignore-existing root@ib1.vir-gol.ir:/var/bigbluebutton/recording/raw/ /var/bigbluebutton/recording/raw/

sudo bbb-record --rebuildall