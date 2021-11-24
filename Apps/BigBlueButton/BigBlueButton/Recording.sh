# -------==========-------
# Mount Old partition
# -------==========-------
# list disk
sudo su
fdisk -l
echo -e "externalDisk=/dev/sdb" | sudo tee -a /etc/environment 
source /etc/environment
mkdir /mnt/hdd
mount -t auto $externalDisk /mnt/hdd
rm -rf  /var/bigbluebutton
ln -s /mnt/hdd/bigbluebutton  /var/bigbluebutton
chown -R bigbluebutton:bigbluebutton /var/bigbluebutton
# Verify
ls -la /var
# -------==========-------
# Move recordings to a different partition
# -------==========-------
# list disk
fdisk -l
echo -e "externalDisk=/dev/sdb" | sudo tee -a /etc/environment 
source /etc/environment
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
sudo bbb-conf --stop
sudo mv /var/bigbluebutton/ /mnt/hdd
# Do this to have backup if sommething goes wrong
# cp -R /mnt/hdd/bigbluebutton /mnt/hdd/bigbluebutton.backup
sudo ln -s /mnt/hdd/bigbluebutton  /var/bigbluebutton
chown -R bigbluebutton:bigbluebutton /var/bigbluebutton
# Verify
ls -la /var
sudo bbb-conf --start
# -------==========-------
# Transfer recordings
# -------==========-------
bbb-record --list
# Run these commands on new server
rsync -rP root@old-bbb-server.vir-gol.ir:/var/bigbluebutton/recording/raw/ /var/bigbluebutton/recording/raw/
rsync -rP root@b2.vir-gol.ir:/var/bigbluebutton/recording/raw/ /var/bigbluebutton/recording/raw/
rsync -rP --ignore-existing root@ib1.vir-gol.ir:/var/bigbluebutton/recording/raw/ /var/bigbluebutton/recording/raw/

sudo bbb-record --rebuildall

# -------==========-------
# Virgol Query to change bbb server
# -------==========-------
# from b3 to b1
UPDATE "Meetings" SET "ServiceId" = '1'
UPDATE "Meetings" SET "ServerURL" = 'https://b1.vir-gol.ir/bigbluebutton/api/'
UPDATE "Meetings" SET "RecordURL" = REPLACE("RecordURL" , 'https://b3' , 'https://b1')