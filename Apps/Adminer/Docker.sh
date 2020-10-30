# -------==========-------
# Adminer
# -------==========-------
docker run \
    --name adminer \
    --link postgresdb:db \
    -e ADMINER_DESIGN='mvt' \
    -p 8080:8080 \
    --restart=always \
    -d adminer

# Alternati designs
    -e ADMINER_DESIGN='pepa-linha-dark' \
    -e ADMINER_DESIGN='mvt' \
    -e ADMINER_DESIGN='nette' \
    -e ADMINER_DESIGN='hydra' \

# Usage with external server
docker run \
    --name adminer \
    -e ADMINER_DEFAULT_SERVER=mysql
    -p 8080:8080 \
    -d adminer