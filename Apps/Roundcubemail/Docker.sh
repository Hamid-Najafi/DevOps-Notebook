# -------==========-------
# Roundcube Docker-Compose
# -------==========-------
cd /home/ubuntu/devops-notebook/Apps/Roundcubemail/
# 1: Comment roundcubemail volumes section in docker-compose.yml  
sudo nano docker-compose.yml 
# volumes:
#       - ./config:/var/roundcube/config/ 
docker-compose up -d
# 2: Wait 60sec to bootstrap database
# 3: unComment volumes sercion
docker rm -f roundcubemail
docker-compose up -d

# -------==========-------
# Roundcube Docker
# -------==========-------
# Step One: 
# Setup MySQL 5.7 Database:
    # 1- New docker container 
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

    # 2- Use Existing container
    # IMPORTANT NOTE: Accessing to root user mySQL from docker container is not allowd, 
    CREATE DATABASE roundcubemail CHARACTER SET utf8 COLLATE utf8_general_ci;
    create user 'roundcube'@'%' IDENTIFIED BY 'Roundcubepass.24';
    GRANT ALL PRIVILEGES  ON roundcubemail.* TO 'roundcube'@'%';
    FLUSH PRIVILEGES;

# Step Two: 
    # Run this to bootstrap database 
    docker run --rm \
        --name roundcubemail \
        -p 8084:80 \
        -e ROUNDCUBEMAIL_DEFAULT_HOST=tls://mail.hamid-najafi.ir \
        -e ROUNDCUBEMAIL_SMTP_SERVER=tls://mail.hamid-najafi.ir \
        -e ROUNDCUBEMAIL_DB_TYPE=mysql \
        -e ROUNDCUBEMAIL_DB_HOST=mysql5.7 \
        -e ROUNDCUBEMAIL_DB_USER=roundcube \
        -e ROUNDCUBEMAIL_DB_PASSWORD=Roundcubepass.24 \
        -e ROUNDCUBEMAIL_DB_NAME=roundcubemail \
        roundcube/roundcubemail
        
# Step Three: 
    # new we can run roundcubemail with custom connfig file
    docker rm -f roundcubemail
    docker run \
        --name roundcubemail \
        -p 8084:80 \
        -v $(pwd)/config/:/var/roundcube/config/ \
        --restart=always \
        -d roundcube/roundcubemail