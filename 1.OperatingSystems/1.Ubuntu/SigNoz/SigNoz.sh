# -------==========-------
# Docker Compose
# -------==========-------
https://signoz.io/docs/install/docker/

git clone -b main https://github.com/SigNoz/signoz.git && cd signoz/deploy/docker
docker compose up -d --remove-orphans
http://localhost:8080/

http://<IP-ADDRESS>:3301/
http://172.25.10.8:3301/