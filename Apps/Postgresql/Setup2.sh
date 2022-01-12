# -------==========-------
# PostgreSQL
# -------==========-------
sudo apt update
sudo apt install -y postgresql postgresql-contrib

# Configure PostgreSQL to accept external connections
echo -e "listen_addresses = '*'" | sudo tee -a /etc/postgresql/12/main/postgresql.conf
echo -e "host    all             all             0.0.0.0/0               md5" | sudo tee -a /etc/postgresql/12/main/pg_hba.conf

sudo systemctl restart postgresql
sudo -i -u postgres psql
SELECT pg_reload_conf();
\q
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