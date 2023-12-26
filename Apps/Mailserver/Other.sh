25 / 465 are blocked


docker network create mailserver-network
docker compose up -d

docker exec -it mailserver sh
cat > /etc/dovecot/dovecot-ldap.conf.ext << EOF
hosts           = 172.25.10.5:389
ldap_version    = 3
auth_bind       = yes
dn              = CN=Administrator,CN=Users,DC=C1Tech,DC=local
dnpass          = C1Techpass.DC
base            = OU=Users,OU=C1Tech,DC=C1Tech,DC=local
scope           = subtree
deref           = never
# Below two are required by command 'doveadm mailbox ...'
iterate_attrs   = mail=user
iterate_filter  = (&(mail=*)(objectClass=person))
user_filter     = (&(mail=%u)(objectClass=person))
pass_filter     = (&(mail=%u)(objectClass=person))
pass_attrs      = userPassword=password
default_pass_scheme = CRYPT
# user_attrs      = mail=master_user,mail=user,=home=/var/vmail/vmail1/%Ld/%Ln/,=mail=maildir:~/Maildir/
user_attrs      = mailHomeDirectory=home,mailUidNumber=uid,mailGidNumber=gid,mailStorageDirectory=mail
EOF
service dovecot stop 

# Postfix and Dovecot SASL
# https://doc.dovecot.org/configuration_manual/howto/postfix_and_dovecot_sasl/
nano /etc/postfix/main.cf
postconf -e smtpd_sasl_type=dovecot
# Located in: /etc/dovecot/conf.d/10-master.conf
postconf -e smtpd_sasl_path=/dev/shm/sasl-auth.sock
postconf -e smtpd_sasl_auth_enable=yes
postconf -e smtpd_relay_restrictions='permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination'
postconf -e virtual_mailbox_domains='c1tech.group'
postconf -e smtpd_sasl_local_domain='c1tech.group'
postconf -e transport_maps='hash:/etc/postfix/transport'
postconf -e virtual_alias_maps=''
postconf -e sender_bcc_maps=''
postconf -e recipient_bcc_maps=''
postconf -e relay_domains=''
postconf -e relay_recipient_maps=''
postconf -e sender_dependent_relayhost_maps=''

cat > /etc/postfix/transport << EOF
c1tech.group dovecot
EOF
postmap hash:/etc/postfix/transport

service postfix stop


# note:
# When configuring service,dont use 'ENABLE_FAIL2BAN'. it will privent several fail attemps and blocks ip...
# Check for PORT Status: 
https://dnschecker.org/port-scanner.php?query=mail.c1tech.group
25, 143, 465, 587, 993




 chmod 770 -R ./docker-data/dms/mail-data/
 chown -R $USER:docker ./docker-data/dms/mail-data/

 mkdir /var/vmail/vmail1