# -------==========-------
# BBB Livestreaming
# -------==========-------
# It have 100Sec delay
cd ~/dev
git clone https://github.com/Hamid-Najafi/BigBlueButton-liveStreaming.git 
cd ~/dev/BigBlueButton-liveStreaming/
docker-compose up -d
docker-compose down
# Join as moderator
https://ib1.vir-gol.ir/bigbluebutton/api/join?fullName=Admin&meetingID=livesteam-1&password=mp&redirect=true&checksum=4bc4b1d088f661c0d9ebe34b177e81dfe5d55388
# Join as attendee
https://ib1.vir-gol.ir/bigbluebutton/api/join?fullName=User&meetingID=livesteam-1&password=ap&redirect=true&checksum=e68c7f594999a5770108b87075398175036ee525
# RTMP
rtmp://live.vir-gol.ir/stream/bbb-live-1
rtmp://live.vir-gol.ir/stream/MEETINGID
# HLS
https://live.vir-gol.ir/hls/bbb-live-1.m3u8
# DASH
https://live.vir-gol.ir/dash/bbb-live-1.mpd