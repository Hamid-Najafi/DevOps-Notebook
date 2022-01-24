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
# Downloadable Recording
# -------==========-------
# To convert all of your current recordings to MP4 format use command:
sudo bbb-record --rebuildall
sudo bbb-record --list
sudo bbb-record --rebuild 9fb761e020658b9cef1d263b6cc0f7a2f86a145d-1632889821115
https://b2.vir-gol.ir/download/presentation/{InternalmeetingID}/{InternalmeetingID}.mp4
https://b3.vir-gol.ir/download/presentation/9fb761e020658b9cef1d263b6cc0f7a2f86a145d-1632889821115/9fb761e020658b9cef1d263b6cc0f7a2f86a145d-1632889821115.mp4
https://b2.vir-gol.ir/playback/presentation/2.3/9c9e16629f9176df30ec52a7d57d46d4c6213274-1618199732033
# Run standalone
/usr/bin/python /usr/local/bigbluebutton/core/scripts/post_publish/download.py 64c863ab0739360c689fc6d45bad5f97fa9c5c8f-1618186276307
cd /usr/local/bigbluebutton/core/scripts/post_publish && ruby download_control.rb -m  64c863ab0739360c689fc6d45bad5f97fa9c5c8f-1618186276307
# Logs
ls -la /var/log/bigbluebutton/download
# Videos
# /var/bigbluebutton/published/presentation &  /var/www/bigbluebutton-default/download/presentation
ls -la /var/bigbluebutton/published/presentation
ls -la /var/bigbluebutton/published/presentation/64c863ab0739360c689fc6d45bad5f97fa9c5c8f-1618186276307/

# -------==========-------
# Virgol Query to change bbb server
# -------==========-------
# from b3 to b1
UPDATE "Meetings" SET "ServiceId" = '1'
UPDATE "Meetings" SET "ServerURL" = 'https://b1.vir-gol.ir/bigbluebutton/api/'
UPDATE "Meetings" SET "RecordURL" = REPLACE("RecordURL" , 'https://b3' , 'https://b1')

