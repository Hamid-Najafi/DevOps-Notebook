echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
curl -sL https://deb.nodesource.com/setup_16.x | sudo bash -
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y mongodb-org

sudo systemctl daemon-reload
sudo systemctl enable mongod
sudo systemctl start mongod
sudo systemctl status mongod

node -v
mongo
# ===============
use admin
db.createUser( { user: "admin",
            pwd: "Mongopass.24",
            roles: [ "userAdminAnyDatabase",
                     "dbAdminAnyDatabase",
                     "readWriteAnyDatabase"] } )
exit
# ======================================
sudo nano /etc/mongod.conf 
# ===============
# These two lines must be uncommented and in the file together:
security:
   authorization: enabled
# ======================================
# Test Database
mongo -u "admin" -p "Mongopass.24"
# ===============
db.adminCommand({listDatabases: 1})
