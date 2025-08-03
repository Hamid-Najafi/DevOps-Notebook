# -------==========-------
# Mongodb
# -------==========-------
docker run \
    --name mongodb \
    -p 27017:27017 \
    -e "MONGO_INITDB_ROOT_USERNAME=admin" \
    -e "MONGO_INITDB_ROOT_PASSWORD=MongoDBpass.24" \
    -v mongoDb:/data/db \
    --restart=always \
    -d mongo  
    # User : admin
# ConnectionString
mongodb://[username:password@]host1[:port1][,...hostN[:portN]][/[defaultauthdb][?options]]
mongodb://myDBReader:D1fficultP%40ssw0rd@mongodb0.example.com:27017/?authSource=admin
mongodb://admin:Mongopass.24@192.168.100.13:27017
