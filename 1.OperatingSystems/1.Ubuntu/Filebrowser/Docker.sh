# -------==========-------
# Filebrowser
# -------==========-------
docker run -d --name filebrowser -v postgresDb:/srv -p 8090:80 filebrowser/filebrowser