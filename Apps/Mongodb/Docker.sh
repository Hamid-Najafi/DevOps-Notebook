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
