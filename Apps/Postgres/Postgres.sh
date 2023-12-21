# -------==========-------
# Docker Compose
# -------==========-------
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/Postgres ~/docker/postgres
cd ~/docker/postgres

sudo mkdir -p /mnt/data/postgres/postgres
sudo mkdir -p /mnt/data/postgres/pgadmin
sudo chmod 770 -R /mnt/data
sudo chown -R $USER:docker /mnt/data/postgres

docker volume create --driver local \
     --opt type=none \
     --opt device=/mnt/data/postgres/postgres \
     --opt o=bind postgres-data

docker volume create --driver local \
     --opt type=none \
     --opt device=/mnt/data/postgres/pgadmin \
     --opt o=bind postgres-pgadmin

docker network create postgres-network

docker compose up -d
# Add New Server -> Connection -> Hostname/Address = postgres, Username = postgres, Password = PostgreSQLpass.24
# -------==========-------
# Docker
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

# PGAdmin 4
docker run \
    --name pgadmin4 \
    -p 8082:80 \
    -e "PGADMIN_DEFAULT_EMAIL=admin@hamid-najafi.ir" \
    -e "PGADMIN_DEFAULT_PASSWORD=pgAdminpass.24" \
    --restart=always \
    -d dpage/pgadmin4
# -------==========-------
# Optimize Postgres
# -------==========-------
# PostgreSQL configuration builder
http://pgconfigurator.cybertec.at/
https://www.pgconfig.org/
https://pgtune.leopard.in.ua/#/

# get CPU(s)
# CPUs = threads per core * cores per socket * sockets
lscpu | grep -E '^Thread|^Core|^Socket|^CPU\('

# Add this to generated config
listen_addresses = '*'

sudo docker exec -it virgol_db sh
# rm /var/lib/postgresql/data/postgresql.conf 
mv /var/lib/postgresql/data/postgresql.conf /var/lib/postgresql/data/postgresql.conf.backup
cat <<EOF > /var/lib/postgresql/data/postgresql.conf
# PASTE CONFIG HERE
EOF
exit
docker restart virgol_db
# -------==========-------
# Connection Strings   
# -------==========-------
User ID=root;Password=myPassword;Host=localhost;Port=5432;Database=myDataBase;Pooling=true;Min Pool Size=0;Max Pool Size=100;Connection Lifetime=0;
User ID=postgres;Password=SugucSkY3k;Host=db.hamid-najafi.ir;Port=5431;
SQLALCHEMY_DATABASE_URL = "postgresql://user:password@postgresserver/db"
SQLALCHEMY_DATABASE_URL = "postgresql://postgres:PostgreSQLpass.24@hpthinclient.local:8081/fastapidb"

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
# -------==========-------
# CLI Connection
# -------==========-------
sudo -i -u postgres
psql
# -------==========-------
# SQL Commands
# -------==========-------
# Set postgres password
ALTER USER postgres PASSWORD 'PostgreSQLpass.24';