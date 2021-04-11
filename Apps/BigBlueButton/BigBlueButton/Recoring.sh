# -------==========-------
# Delete recordings older than N days
# -------==========-------
sudo nano /etc/cron.daily/bbb-recording-cleanup

#!/bin/bash

MAXAGE=12

LOGFILE=/var/log/bigbluebutton/bbb-recording-cleanup.log

shopt -s nullglob

NOW=$(date +%s)

echo "$(date --rfc-3339=seconds) Deleting recordings older than ${MAXAGE} days" >>"${LOGFILE}"

for donefile in /var/bigbluebutton/recording/status/published/*-presentation.done ; do
        MTIME=$(stat -c %Y "${donefile}")
        # Check the age of the recording
        if [ $(( ( $NOW - $MTIME ) / 86400 )) -gt $MAXAGE ]; then
                MEETING_ID=$(basename "${donefile}")
                MEETING_ID=${MEETING_ID%-presentation.done}
                echo "${MEETING_ID}" >> "${LOGFILE}"

                bbb-record --delete "${MEETING_ID}" >>"${LOGFILE}"
        fi
done

for eventsfile in /var/bigbluebutton/recording/raw/*/events.xml ; do
        MTIME=$(stat -c %Y "${eventsfile}")
        # Check the age of the recording
        if [ $(( ( $NOW - $MTIME ) / 86400 )) -gt $MAXAGE ]; then
                MEETING_ID="${eventsfile%/events.xml}"
                MEETING_ID="${MEETING_ID##*/}"
                echo "${MEETING_ID}" >> "${LOGFILE}"

                bbb-record --delete "${MEETING_ID}" >>"${LOGFILE}"
        fi
done

chmod +x /etc/cron.daily/bbb-recording-cleanup
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
