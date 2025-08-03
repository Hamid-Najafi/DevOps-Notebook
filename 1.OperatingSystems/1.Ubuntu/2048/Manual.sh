# -------==========-------
# 2046
# -------==========-------
cd ~/dev
git clone https://github.com/Goldenstarc/docker-2048.git
cd docker-2048
docker run --name 2048 -p 8088:80 -v $(pwd)/2048:/usr/share/nginx/html:ro -d nginx