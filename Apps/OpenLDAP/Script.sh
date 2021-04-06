# -------==========-------
# Where to put LDAPS certificate
# -------==========-------
1- Inside docker image - connect LDAP container directrly to host:
like what we did
2- (Not recommended)In reverse proxy LDAPS->LDAP - put LDAP Container after reverse proxy:
Nginx example
https://jackiechen.blog/2019/01/24/nginx-sample-config-of-http-and-ldaps-reverse-proxy/
Traefik Ddesnt support LDAPS
# -------==========-------
# 1.A:Build Exrended LDAP
# -------==========-------
mkdir ~/dev
cd ~/dev
git clone https://github.com/Goldenstarc/extended-docker-openldap.git
export DOMAIN="ldap.vir-gol.ir"
openssl dhparam -out ~/dev/extended-docker-openldap/certs/dhparam.pem 2048
sudo snap install --classic certbot
sudo certbot certonly \
    --manual \
    --preferred-challenges dns \
    --email admin@legace.ir \
    --agree-tos \
    --domains $DOMAIN
sudo cp -RL /etc/letsencrypt/live/$DOMAIN/. ~/dev/extended-docker-openldap/certs/
sudo chown $USER:$USER -R ~/dev/extended-docker-openldap/certs/
cd extended-docker-openldap
# nano environment/my-env.startup.yaml
docker build -t goldenstarc/extended-openldap -t goldenstarc/extended-openldap:1.4.0 .
docker push goldenstarc/extended-openldap
git config --global --edit
git add .
git commit -m "set certs" -a
git push
# -------==========-------
# 1.B:Extended LDAP
# -------==========-------
# Username: cn=admin,dc=legace,dc=ir , Password: OpenLDAPpass.24

# 1.Run with docker
docker run \
--name ldap-service \
--volume openldapDb:/var/lib/ldap \
--volume openldapConf:/etc/ldap/slapd.d \
--restart=always \
--net="host" \
-d goldenstarc/extended-openldap:1.4.0

# For Testing Purpose
docker run \
--name ldap-service \
--restart=always \
-p 389:389 \
goldenstarc/extended-openldap

docker run \
--name ldap-service \
--volume openldapDb:/var/lib/ldap \
--volume openldapConf:/etc/ldap/slapd.d \
--restart=always \
-p 390:389 \
-d goldenstarc/extended-openldap:1.4.0


docker run \
--name ldapService_Temp \
--volume openldapDb_Temp:/var/lib/ldap \
--volume openldapConf_Temp:/etc/ldap/slapd.d \
-e LDAP_ADMIN_PASSWORD=JonSn0w \
--restart=always \
-p 390:389 \
-d goldenstarc/extended-openldap:1.4.0
# 2.Run with docker compose
cd ~/virgol/
docker-compose up -d
# Test
ldapsearch -x -h "ldap.legace.ir" -b "dc=legace,dc=ir" -D "cn=admin,dc=legace,dc=ir" -w "OpenLDAPpass.24"
# -------==========-------
# 2.osixia/openldap
# -------==========-------
# User: cn=admin,dc=example,dc=org , Password: admin
docker run \
--name ldap-service \
--volume openldapDb:/var/lib/ldap \
--volume openldapConf:/etc/ldap/slapd.d \
-p 389:389 \
-p 636:636 \
--restart=always \
--detach  osixia/openldap:1.4.0

docker run \
--name ldap-service \
--volume openldapDb:/var/lib/ldap \
--volume openldapConf:/etc/ldap/slapd.d \
--net="host" \
--restart=always \
--detach  osixia/openldap:1.4.0

# -------==========-------
# osixia/phpldapadmin
# -------==========-------
# Username: cn=admin,dc=legace,dc=ir
# Password: OpenLDAPpass.24
docker run \
--name phpldapadmin \
--hostname phpldapadmin.legace.ir \
-p 8083:80 \
--link ldap-service:ldap-host \
--env PHPLDAPADMIN_LDAP_HOSTS=ldap-host \
--env PHPLDAPADMIN_HTTPS=false \
--env PHPLDAPADMIN_LDAP_CLIENT_TLS=false \
--restart=always \
-d osixia/phpldapadmin
# -------==========-------
# osixia/openldap-backup
# -------==========-------
  docker run \
  --env LDAP_BACKUP_CONFIG_CRON_EXP="0 5 * * *" \
  --volume openldapDb:/home/ubuntu/data/backup \
  --detach osixia/openldap-backup

# -------==========-------
# Configurations
# -------==========-------
# OpenLDAP Software 2.4 Administrator's Guide
https://www.openldap.org/doc/admin24/index.html
https://www.openldap.org/devel/admin/index.html


# -------==========-------
# LDAP Commands
# -------==========-------
# Search
ldapsearch -x -h "su.legace.ir:389" -b "dc=example,dc=org " -D "cn=admin,dc=example,dc=org" -w "admin"
ldapsearch -x -h "conf.legace.ir:390" -b "dc=example,dc=org " -D "cn=admin,dc=example,dc=org" -w "admin"
# Add Users & Groups : 
ldapadd -D "cn=admin,dc=legace,dc=ir" -f userimport-*.ldif -h ldap://ldap.legace.ir/ -W OpenLDAPpass.24
