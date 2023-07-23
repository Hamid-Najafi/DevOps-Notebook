# -------==========-------
# InfluxDB
# -------==========-------
docker run \
    --name influxdb \
    -v influxdb:/var/lib/influxdb \
    --restart=always \
    -p 8086:8086 \
    -p 2003:2003 \
    -e INFLUXDB_GRAPHITE_ENABLED=true \
    -e INFLUXDB_ADMIN_USER=influxdb \
    -e INFLUXDB_ADMIN_PASSWORD=InfluxDBpass.24 \
    -d influxdb
    
http://influxdb.hamid-najafi.ir:8086  -u influxdb:InfluxDBpass.24

# Creating a DB named mydb:
curl -i -XPOST http://influxdb.hamid-najafi.ir:8086/query --data-urlencode "q=CREATE DATABASE mydb"
# Inserting into the DB:
curl -i -XPOST 'http://localhost:8086/write?db=mydb' --data-binary 'cpu_load_short,host=server01,region=us-west value=0.64 1434055562000000000'
