# -------==========-------
# MariaDB
# -------==========-------
sudo apt install mariadb-server -y
sudo mysql_secure_installation

# Configure MariaDB to accept external connections
sed -i '/bind-address/s/^/#/g' /etc/mysql/mariadb.conf.d/50-server.cnf
/etc/init.d/mysql restart
# -------==========-------
# CLI Connection
# -------==========-------
mysql
mysql -u [username] -p
mysql --user=root --password
# -------==========-------
# SQL Commands
# -------==========-------
# Set root password
SET PASSWORD FOR 'root'@'%' = PASSWORD('mySQLpass.24');
FLUSH PRIVILEGES;

# Update root password
UPDATE mysql.user
SET authentication_string=PASSWORD('mySQLpass.24')
WHERE user='root';
FLUSH PRIVILEGES;

# MySQL root access from all hosts
CREATE USER 'root'@'%' IDENTIFIED BY 'mySQLpass.24';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

# List Users
SELECT user,host,password FROM mysql.user;

# Create User
CREATE USER 'C1Tech'@'%' IDENTIFIED BY 'mySQLpass.24';

# Create Database
DROP DATABASE C1TechHMS;

CREATE DATABASE HospitalManagements;
GRANT ALL PRIVILEGES ON HospitalManagements.* TO 'C1Tech'@'%';
FLUSH PRIVILEGES;

GRANT ALL PRIVILEGES ON * . * TO 'root'@'%';
FLUSH PRIVILEGES;

SHOW GRANTS FOR 'username'@'localhost';

DROP USER 'C1TechHMS'@'localhost';



