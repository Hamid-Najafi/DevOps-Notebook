# -------==========-------
# S3 Storage Server
# -------==========-------
first setup MinIO as S3 compatible server 

# -------==========-------
# Schedule Backup
# -------==========-------
# There is no need to make bucket in S3
    docker run -d \
    --name volumerize \
    --restart=always \
    -v virgol_virgolData:/source/virgolData:ro \
    -v virgol_postgresDb:/source/postgresDb:ro \
    -v virgol_openldapDb:/source/openldapDb:ro \
    -v virgol_openldapConf:/source/openldapConf:ro \
    -v virgol_moodle:/source/moodle:ro \
    -v virgol_moodleData:/source/moodleData:ro \
    -v virgol_mariaDb:/source/mariaDb:ro \
    -v volumerize_backup:/backup \
    -v volumerize_cache:/volumerize-cache \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e "VOLUMERIZE_JOBBER_TIME=0 0 0 * * *" \
    -e "TZ=Asia/Tehran" \
    -e "VOLUMERIZE_SOURCE=/source" \
    -e "VOLUMERIZE_TARGET=s3://minio.goldenstarc.ir/virgol" \
    -e "VOLUMERIZE_CONTAINERS=virgol_main virgol_db virgol_moodle virgol_moodle_db virgol_openldap" \
    -e "AWS_ACCESS_KEY_ID=minio" \
    -e "AWS_SECRET_ACCESS_KEY=MinIOpass.24" \
    blacklabelops/volumerize backup

# Run Manual Backup
 docker exec volumerize backup

# -------==========-------
# Restore Latest
# -------==========-------
    docker run --rm \
    -v virgol_virgolData:/source/virgolData \
    -v virgol_postgresDb:/source/postgresDb \
    -v virgol_openldapDb:/source/openldapDb \
    -v virgol_openldapConf:/source/openldapConf \
    -v virgol_moodle:/source/moodle \
    -v virgol_moodleData:/source/moodleData \
    -v virgol_mariaDb:/source/mariaDb \
    -v backup_volume:/backup:ro \
    -v cache_volume:/volumerize-cache \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e "VOLUMERIZE_SOURCE=/source" \
    -e "VOLUMERIZE_TARGET=s3://minio.goldenstarc.ir/virgol" \
    -e "VOLUMERIZE_CONTAINERS=virgol_main virgol_db virgol_moodle virgol_moodle_db virgol_openldap" \
    -e "AWS_ACCESS_KEY_ID=minio" \
    -e "AWS_SECRET_ACCESS_KEY=MinIOpass.24" \
    blacklabelops/volumerize restore