# -------==========-------
# Postgres
# -------==========-------
docker run \
    --name postgres \
    -e "POSTGRES_PASSWORD=PostgreSQLpass.24" \
    -p 5432:5432 \
    -v postgresDb:/var/lib/postgresql/data \
    --restart=always \
    -d postgres

    command: postgres -c 'max_connections=200'
    # User : postgres

# TEMP
docker run \
    --name postgres \
    -e "POSTGRES_PASSWORD=JonSn0w" \
    -p 5433:5432 \
    -v postgresDb_Temp:/var/lib/postgresql/data \
    --restart=always \
    -d postgres

# PGAdmin 4
docker run \
    --name pgadmin4 \
    -p 8081:80 \
    -e "PGADMIN_DEFAULT_EMAIL=admin@legace.ir" \
    -e "PGADMIN_DEFAULT_PASSWORD=pgAdminpass.24" \
    --restart=always \
    -d dpage/pgadmin4

User ID=root;Password=myPassword;Host=localhost;Port=5432;Database=myDataBase;Pooling=true;Min Pool Size=0;Max Pool Size=100;Connection Lifetime=0;
User ID=postgres;Password=SugucSkY3k;Host=db.legace.ir;Port=5431;

# -------==========-------
# Optimize Postgres
# -------==========-------
# PostgreSQL configuration builder
https://www.pgconfig.org/

sudo docker exec -it virgol_db sh
# rm /var/lib/postgresql/data/postgresql.conf 
mv /var/lib/postgresql/data/postgresql.conf /var/lib/postgresql/data/postgresql.conf.backup
cat <<EOF > /var/lib/postgresql/data/postgresql.conf
# PASTE CONFIG HERE
EOF
exit
docker restart virgol_db

# -------==========-------
# Upgrade Postgres Version   
# -------==========-------
1) Backup database
2) Shutdown postgres 12 container
3) Run new postgres 13 container
4) Restore backup
# -------==========-------
# Backup PostgreSQL CLI
# -------==========-------
sudo sh -c 'docker exec -t your-db-container pg_dumpall -c -U postgres > dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql'
# **** Exapmles *** #
# Virgol
sudo sh -c 'docker exec -t virgol_db pg_dumpall -c -U postgres > dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql'
# Grafana
sudo sh -c 'docker exec -t monitoring_postgres_1 pg_dumpall -c -U grafana > dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql'
# -------==========-------
# Restore PostgreSQL CLI:
# -------==========-------
cat your_dump.sql | docker exec -i your-db-container psql -U postgres
# **** Exapmles *** #
# Virgol
cat dump.sqlc
# -------==========-------
# Filebrowser
# -------==========-------
docker run -d --name filebrowser -v postgresDb:/srv -p 8090:80 filebrowser/filebrowser