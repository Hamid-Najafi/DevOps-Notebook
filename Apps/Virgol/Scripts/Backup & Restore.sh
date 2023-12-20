# -------==========-------
# S3 Storage Server
# -------==========-------
# first setup MinIO as S3 compatible server 
# Setup traefik
mkdir -p ~/docker/minio
cp -R ~/DevOps-Notebook/Apps/MinIO/*  ~/docker/minio
cd  ~/docker/minio
# Set Host
    #   - "traefik.http.routers.traefik.rule=Host(`minio.hamid-najafi.ir`)"
nano docker-compose.yml
docker compose up -d
# ACCESS_KEY=minio
# SECRET_KEY=MinIOpass.24
# -------==========-------
# Schedule Backup
# -------==========-------
# There is no need to make bucket in S3

# Realtime Backup
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
-e "VOLUMERIZE_SOURCE=/source" \
-e "VOLUMERIZE_TARGET=s3://s3.hamid-najafi.ir/virgoool" \
-e "VOLUMERIZE_CONTAINERS=virgol_main virgol_db virgol_moodle virgol_moodle_db virgol_openldap" \
-e "AWS_ACCESS_KEY_ID=minio" \
-e "AWS_SECRET_ACCESS_KEY=MinIOpass.24" \
blacklabelops/volumerize backup

# Daily backup at 12:00 AM
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
-e "VOLUMERIZE_TARGET=s3://s3.hamid-najafi.ir/virgol" \
-e "VOLUMERIZE_CONTAINERS=virgol_main virgol_db virgol_moodle virgol_moodle_db virgol_openldap" \
-e "AWS_ACCESS_KEY_ID=minio" \
-e "AWS_SECRET_ACCESS_KEY=MinIOpass.24" \
blacklabelops/volumerize backup

# Run Manual Backup
 docker exec volumerize backup

# -------==========-------
# Restore Backups
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
-e "VOLUMERIZE_TARGET=s3://s3.hamid-najafi.ir/virgol" \
-e "VOLUMERIZE_CONTAINERS=virgol_main virgol_db virgol_moodle virgol_moodle_db virgol_openldap" \
-e "AWS_ACCESS_KEY_ID=minio" \
-e "AWS_SECRET_ACCESS_KEY=MinIOpass.24" \
blacklabelops/volumerize restore

# -------==========-------
# Traditional Backup
# -------==========-------
# postgres
sudo sh -c 'docker exec -t postgres pg_dumpall -c -U postgres > dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql'
sudo sh -c 'docker exec -t virgol_db pg_dumpall -c -U postgres > dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql'
ca dump.sql | docker exec -i postgres psql -U postgres
ca dump.sql | docker exec -i virgol_db psql -U postgres

# moodle
sudo zip -r ~/backup/moodle_`date +%d-%m-%Y"_"%H_%M_%S`.zip /docker

# move data from /docker/ to docker volume
docker run -v virgol_moodle:/data --name helper busybox true
cd /home/ubuntu/docker/moodle-bitnami
sudo docker cp . helper:/data
docker rm -f helper

docker run -v virgol_moodleData:/data --name helper busybox true
cd /home/ubuntu/docker/moodle-data-bitnami
sudo docker cp . helper:/data
docker rm -f helper

docker run -v virgol_mariaDb:/data --name helper busybox true
cd /home/ubuntu/docker/moodle-bitnami
sudo docker cp . helper:/data
docker rm -f helper

sudo chmod 777 -R /var/lib/docker/volumes/virgol_moodle/
sudo chmod 777 -R /var/lib/docker/volumes/virgol_moodleData/
sudo chmod 777 -R /var/lib/docker/volumes/virgol_mariaDb


# openldap
sudo mkdir -p ~/backup/ldap/openldapConf 
sudo mkdir -p ~/backup/ldap/openldapDb 

docker run --rm \
-v ~/backup:/backups \
--volumes-from ldap-service \
busybox cp -a /etc/ldap/slapd.d /backups/ldap/openldapConf

docker run --rm \
-v ~/backup:/backups \
--volumes-from ldap-service \
busybox cp -a /var/lib/ldap /backups/ldap/openldapDb

cd ~/backup
sudo zip -r openldap_`date +%d-%m-%Y"_"%H_%M_%S`.zip ~/backup/ldap
