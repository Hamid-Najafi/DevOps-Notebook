# -------==========------- 
# mosquitto
# -------==========------- 
# Install mosquitto
docker pull eclipse-mosquitto
docker run -it --name mosquitto -p 1883:1883 eclipse-mosquitto