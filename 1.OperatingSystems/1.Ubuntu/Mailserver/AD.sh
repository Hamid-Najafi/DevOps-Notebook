# For Active Directory (NOT RECOMMENDED)

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
user_attrs      = mailHomeDirectory=home,mailUidNumber=uid,mailGidNumber=gid,mailStorageDirectory=mail
EOF
service dovecot stop 

# Postfix and Dovecot SASL
# https://doc.dovecot.org/configuration_manual/howto/postfix_and_dovecot_sasl/
nano /etc/postfix/main.cf
postconf -e smtpd_sasl_type=dovecot
# Located in: /etc/dovecot/conf.d/10-master.conf
service postfix stop


base = ou=users,dc=c1tech,dc=group
default_pass_scheme = SSHA
dn = cn=admin,dc=c1tech,dc=group
dnpass = LDAPpass.24
uris = ldaps://ldap.c1tech.group:636
tls = no
ldap_version        = 3
pass_attrs          = uniqueIdentifier=user,userPassword=password
pass_filter = (&(objectClass=PostfixBookMailAccount)(uniqueIdentifier=%n))
user_attrs          = mailHomeDirectory=home,mailUidNumber=uid,mailGidNumber=gid,mailStorageDirectory=mail
user_filter = (&(objectClass=PostfixBookMailAccount)(uniqueIdentifier=%n))
auth_bind = no