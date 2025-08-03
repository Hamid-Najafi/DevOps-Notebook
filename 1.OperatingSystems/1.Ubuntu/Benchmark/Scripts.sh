# -------==========-------
# HTTP
# -------==========-------
# ab - Apache HTTP server benchmarking tool


# -------==========-------
# LDAP
# -------==========-------
# lb - LDAP benchmarking tool like an Apache Bench

lb setup base -b 'cn=admin,dc=hamid-najafi,dc=ir' ldap://localhost/
lb setup base -b 'dc=example,dc=org' -w 'admin' ldap://conf.hamid-najafi.ir:390/
ldapsearch -x -h "conf.hamid-najafi.ir:390" -b "dc=example,dc=org " -D "cn=admin,dc=example,dc=org" -w "admin"