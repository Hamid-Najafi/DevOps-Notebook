# -------==========-------
# Credintials
# -------==========-------

SQL Server Database Password
Serverpass24!@#$

Adobe Connect Administrator User
admin@legace.ir
Connectpass.24

# Console Settings
http://localhost:8510/console

# Firewall Ports:
80 an 443 and 1945 for RTMP traffic 

# Stunnel install location
C:\Connect\stunnel\
mkdir C:\Connect\stunnel\certs

# Certbot install
https://dl.eff.org/certbot-beta-installer-win32.exe
certbot certonly --standalone  --preferred-challenges http -d m1.legace.ir
C:\Certbot\live\c1.legace.ir\
C:\Certbot\live\m1.legace.ir\

>C:\Users\Administrator\Desktop\stunnel-5.56-win64-installer.exe -install

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
https://c1.legace.ir/

Administration -> Users andd Groups -> Edit Login and Password Policies -> Login Policy -> Use e-mail address as the login: No

http://localhost:8510/console/directory-service-settings/directory-service-settings/connection-settings

URL:ldap://ldap.legace.ir:389
Authentication mechanism:Simple
UserName:cn=admin,dc=legace,dc=ir
Password:password123
Query timeout:120
Query page size:100

http://localhost:8510/console/directory-service-settings/directory-service-settings/user-profile-mapping
Login:uniqueIdentifier
FirstName:givenName 
LastName:sn 
Email:mail 

<!-- NetworkLogin:mail -->
ou=people,dc=legace,dc=ir
Filter:(objectClass=person) 
Filter:(mailEnabled=TRUE)
Subtree search:True

Enable LDAP Directory authentication : Checked
Enable Adobe Connect fall-back on unsuccessful LDAP Directory authentication : Checked
 Create Adobe Connect user account upon successful LDAP Directory authentication : Checked
Select the type of Adobe Connect user account to be created: External
