# -------==========-------
# Where to put LDAPS certificate
# -------==========-------
1- Inside docker image - connect LDAP container directrly to host:
like what we did
2- In reverse proxy LDAPS->LDAP - put LDAP Container after reverse proxy:
Nginx example
https://jackiechen.blog/2019/01/24/nginx-sample-config-of-http-and-ldaps-reverse-proxy/
# -------==========-------
# 1.A:Build Exrended LDAP
# -------==========-------
mkdir dev
cd dev
git clone https://github.com/Goldenstarc/extended-docker-openldap.git
openssl dhparam -out ~/dev/extended-docker-openldap/certs/dhparam.pem 2048
sudo certbot certonly --standalone -d ldap.legace.ir
sudo certbot certonly --nginx -d ldap.legace.ir
sudo certbot certonly --apache -d ldap.legace.ir
sudo cp -RL /etc/letsencrypt/live/ldap.legace.ir/. ~/dev/extended-docker-openldap/certs/
sudo chown ubuntu:ubuntu -R ~/dev/extended-docker-openldap/certs/
cd ~/dev/extended-docker-openldap
docker tag goldenstarc/extended-openldap:1.4.0 goldenstarc/extended-openldap:latest
docker build -t goldenstarc/extended-openldap:1.4.0 .
docker push goldenstarc/extended-openldap
# -------==========-------
# 1.B:Extended LDAP
# -------==========-------
# ENV Variables are saved inside docker container during image build.
# in my-env.startup.yaml
docker run \
--name ldap-service \
--hostname ldap.legace.ir \
--volume openldapDb:/var/lib/ldap \
--volume openldapConf:/etc/ldap/slapd.d \
--restart=always \
-p 389:389 \
-p 636:636 \
-d goldenstarc/extended-openldap
# -------==========-------
# 2.osixia/openldap
# -------==========-------
# Add Users & Groups : 
ldapadd -W -D "cn=admin,dc=legace,dc=ir" -f userimport-*.ldif -h ldap.legace.ir

docker run \
--name ldap-service \
--hostname ldap.legace.ir \
--env LDAP_TLS=true \
--env LDAP_ADMIN_PASSWORD="OpenLDAPpass.24" \
--env LDAP_ORGANISATION="Legace" \
--env LDAP_DOMAIN="legace.ir" \
--env LDAP_TLS_VERIFY_CLIENT=try \
--volume openldapDb3:/var/lib/ldap \
--volume openldapConf3:/etc/ldap/slapd.d \
-p 389:389 \
-p 636:636 \
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