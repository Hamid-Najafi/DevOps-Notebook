# -------==========-------
# volumerize
# -------==========-------
docker run -it --rm \
    --name volumerize \
    -v yourvolume:/source:ro \
    -v backup_volume:/backup \
    -v cache_volume:/volumerize-cache \
    -e "VOLUMERIZE_SOURCE=/source" \
    -e "VOLUMERIZE_TARGET=file:///backup" \
    blacklabelops/volumerize backup

 docker exec volumerize backup
