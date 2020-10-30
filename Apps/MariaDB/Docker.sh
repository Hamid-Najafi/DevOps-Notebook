# -------==========-------
# MariaDB
# -------==========-------
docker run \
    --name mariadb \
    -p 3306:3306 \
    -e MYSQL_ROOT_PASSWORD="mySQLpass.24" \
    -v MariaDb:/var/lib/mysql \
    --restart=always \
    -d mariadb
# PhpMyAdmin
docker run \
    --name phpmyadmin \
    -e PMA_ABSOLUTE_URI=https://phpmyadmin.legace.ir/ \
    --link mariadb:db \
    -p 8082:80 \
    --restart=always \
    -d phpmyadmin/phpmyadmin



docker run \
    --name phpmyadmin \
    --link moodle_mariadb_1:db \
    -p 9100:80 \
    --restart=always \
    --net moodle_database_network \
    --net host \
    -d phpmyadmin/phpmyadmin
