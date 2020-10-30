# -------==========-------
# Oracle MySQL 5.7
# -------==========-------
docker run \
    --name mysql5.7 \
    -p 3306:3306 \
    -e "MYSQL_ROOT_PASSWORD=mySQLpass.24" \
    -e "MYSQL_DATABASE=roundcubemail" \
    -e "MYSQL_USER=roundcube" \
    -e "MYSQL_PASSWORD=Roundcubepass.24" \
    -v mysqlDb:/var/lib/mysql  \
    --restart=always \
    -d mysql:5.7
    # User : root
# ConnectionString
Server=legace.ir;Database=nopCommerce;Uid=root;Pwd=mySQLpass.24;
# PhpMyAdmin
docker run \
    --name phpmyadmin \
    -e PMA_ABSOLUTE_URI=https://phpmyadmin.legace.ir/ \
    -p 8082:80 \
    --link mysql5.7:db \
    --restart=always \
    -d phpmyadmin/phpmyadmin
