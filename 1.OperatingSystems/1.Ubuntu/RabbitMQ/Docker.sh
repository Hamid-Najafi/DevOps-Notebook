# -------==========-------
# RabbitMQ
# -------==========-------
# Daemon
docker run -d --net=host --hostname my-rabbit --name some-rabbit rabbitmq:3
# Management Plugin
docker run -d --net=host  --hostname my-rabbit --name manag-rabit -e rabbitmq:3-management