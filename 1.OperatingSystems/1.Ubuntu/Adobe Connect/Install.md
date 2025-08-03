
# -------==========-------
# Server
# -------==========-------
Minimum
4GB Ram
4 Core CPU
# -------==========-------
# Credintials
# -------==========-------

SQL Server Database Password
Serverpass24!@#$

Adobe Connect Administrator User
admin@hamid-najafi.ir
Connectpass.24

# Console Settings
http://localhost:8510/console

# Open Firewall Ports:
80 an 443 and 1945 for RTMP traffic 

## Certbot
# Install Certbot 
https://dl.eff.org/certbot-beta-installer-win32.exe
# Generate Cert
certbot certonly --standalone  --preferred-challenges http -d c1.vir-gol.ir
# Certs location
C:\Certbot\live\c1.vir-gol.ir\

## Stunnel
# Install Stunnel
C:\Users\Administrator\Desktop\stunnel-5.56-win64-installer.exe -install
# Installation Location
C:\Connect\stunnel\
mkdir C:\Connect\stunnel\certs
## Set Configucarion
# Adobe configs
C:\Connect\10.8.0\custom.ini
C:\Connect\10.8.0\appserv\conf\server.xml
# Stunnel config
C:\Connect\Stunnel\config\stunnel.conf
# Load Configs
open Stunnel, Configuration -> Reload Configuration


# Adobe Connect Services Autostart
Send a copy from Start "Adobe Connect Central Application Server" and "Start Adobe Connect Meeting Server" to startup folder
C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Adobe Connect Server
%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp

# Adobe Connect Meeting Server
net start AMS
net stop AMS
#  Adobe Connect Central Application Server
net start ConnectPro
net stop ConnectPro

# Stunnel auto-start on reboot
Windows logo key  + R, type shell:startup, then select OK. This opens the Startup folder.
Copy and paste the shortcut to the app from the file location to the Startup folder.

# -------==========-------
# Fonts
# -------==========-------
?!

# -------==========-------
# LDAP
# -------==========-------
https://c1.hamid-najafi.ir/

Administration -> Users andd Groups -> Edit Login and Password Policies -> Login Policy -> Use e-mail address as the login: No

http://localhost:8510/console/directory-service-settings/directory-service-settings/connection-settings

URL:ldap://ldap.vir-gol.ir:390
Authentication mechanism:Simple
UserName:cn=admin,dc=hamid-najafi,dc=ir
Password:password123
Query timeout:120
Query page size:100

http://localhost:8510/console/directory-service-settings/directory-service-settings/user-profile-mapping
Login:uniqueIdentifier
FirstName:givenName 
LastName:sn 
Email:mail 

<!-- NetworkLogin:mail -->
ou=people,dc=hamid-najafi,dc=ir
# FILTER 1
Filter:(objectClass=person) 
# OR FILTER 2 (WITH POSTFIX BOOKMAIL)
Filter:(mailEnabled=TRUE)
Subtree search:True

Enable LDAP Directory authentication : Checked
Enable Adobe Connect fall-back on unsuccessful LDAP Directory authentication : Checked
 Create Adobe Connect user account upon successful LDAP Directory authentication : Checked
Select the type of Adobe Connect user account to be created: External
