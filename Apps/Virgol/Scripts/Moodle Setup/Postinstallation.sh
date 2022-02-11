# Username: admin 
# Password: wydta4-voqvAb-vadpaf
# -------==========-------
# Setup Web Service
# -------==========-------
0 - https://m-dei.vir-gol.ir/admin/category.php?category=webservicesettings
Overview
# -------==========-------
1 - https://m-dei.vir-gol.ir/admin/search.php?query=enablewebservices
Enable web services
# -------==========-------
2 - https://m-dei.vir-gol.ir/admin/settings.php?section=webserviceprotocols
Enable REST Protocol
# -------==========-------
3 - https://m-dei.vir-gol.ir/user/editadvanced.php?id=-1
Create a specific user	
  Username : webapiuser
  New password : API-User1234 (doesnt matter)
  First name : web
  Surname : api
  Email address : web@api.com
# -------==========-------
4 - https://m-dei.vir-gol.ir/admin/roles/manage.php
Create Role with REST permissions
  Use role or archetype: ArchType:Manager 
  Click on Continue
  Short name : apirole
  Custom full name : apirole
  Context types where this role may be assigned : check 'user' to true
  Allow role assignments : add "Authenticated User" to selected
  Filter :
 Web service: REST protocol :use = allow
# -------==========-------
5 - https://m-dei.vir-gol.ir/admin/roles/assign.php?contextid=1&roleid=9
Assign Role (apiitole) to Webservice User (webapiuser)
  select webapi user From rightList then click on add
# -------==========-------
6 - https://m-dei.vir-gol.ir/admin/webservice/service.php?id=0
Create System Service
     Name : apiservice
     Short name : apiservice
     Enabled : true
     Authorised users only  : true
# -------==========-------
7 - https://m-dei.vir-gol.ir/admin/webservice/service_functions.php?id=2
  Add Functions to Service
    core_course_create_categories
    core_course_create_courses
    core_course_delete_categories
    core_course_delete_courses
    core_course_get_categories
    core_course_get_contents
    core_course_get_courses
    core_course_get_courses_by_field
    core_course_update_categories
    core_course_update_courses
    core_enrol_get_enrolled_users
    core_enrol_get_users_courses
    core_user_create_users
    core_user_delete_users
    core_user_get_users
    core_user_get_users_by_field
    core_user_update_users
    enrol_manual_enrol_users
    enrol_manual_unenrol_users
# -------==========-------
8 - https://m-dei.vir-gol.ir/admin/webservice/service_users.php?id=2
Assign Service (apiservice) to Webservice User (webapiuser)
  select webapi user From rightList then click on add
# -------==========-------
9 - https://m-dei.vir-gol.ir/admin/settings.php?section=webservicetokens
  Generate Web Service Token
  User : web api
  Service : apiservice
# -------==========-------
10 - Set token in Virgol Database || Docker-Compose
# -------==========-------
# Setup LDAP
# -------==========-------
1 - https://m-dei.vir-gol.ir/admin/settings.php?section=manageauths
; Available authentication plugins
-- Disable Email-based self-registration
-- Enable LDAP server
-- Enable Web services authentication
----------------------------------------
; Common settings
-- Allow log in via email : true
-- Prevent account creation when authenticating : true
-- Autofocus login page form : true
-- Guest login button = Hide
-- Limit concurrent logins  = 1
-- Alternate login URL : "https://dei.razaviedu.ir/SSO"
# -------==========-------
2 - https://m-dei.vir-gol.ir/admin/settings.php?section=authsettingldap
  LDAP settings
    Host URL : ldap://ldap.vir-gol.ir:390/
    Host URL : ldap://virgol_openldap/
  Bind settings
    Distinguished name : cn=admin,dc=legace,dc=ir
    Password : OpenLDAPpass.24
  User lookup settings
    Context : ou=people,dc=legace,dc=ir
    User attribute : uniqueidentifier
  Data mapping
    Data mapping (First name) : cn
    Update local (First name) : On Every login

    Data mapping (Surname) : sn
    Update local (Surname) : On Every login

    Data mapping (Email address) : mail
    Update local (Email address) : On Every login

    Data mapping (ID number) : employeeNumber
    Update local (ID number) : On Every login
# -------==========-------
# Customize Moodle
# -------==========-------
# Admin page
https://m-dei.vir-gol.ir/admin/search.php
# -------==========-------
1- Add Persian lang:
https://m-dei.vir-gol.ir/admin/tool/langimport/index.php

https://m-dei.vir-gol.ir/admin/settings.php?section=langsettings
-- Language autodetect = no
-- Default language = فارسی
# -------==========-------
2- Add Persian Cal & set to default
https://m-dei.vir-gol.ir/admin/tool/installaddon/index.php
--install Persian Cal From PluginFolder

https://m-dei.vir-gol.ir/admin/settings.php?section=calendar
Calendar type : persian
Admins see all : true
Time display format : 12h
Start of week : saturday
Weekend days :Thursday, friday
4- Set Location, Country:
https://m-dei.vir-gol.ir/admin/settings.php?section=locationsettings
Default TimeZone : Asia/Tehran
Default Country : Iran
# -------==========-------
3-  GeoLite2 City MaxMind DB 
docker exec -it moodle_moodle_1 mkdir /bitnami/moodledata/geoip/ 
docker cp ~/GeoLite2-City.mmdb moodle_moodle_1:/bitnami/moodledata/geoip/GeoLite2-City.mmdb  
# -------==========-------
4- Front page settings 
https://m-dei.vir-gol.ir/admin/settings.php?section=frontpagesettings 
# -------==========-------
5- https://m-dei.vir-gol.ir/admin/settings.php?section=manageantiviruses
-- ClamAV antivix
# -------==========-------
6- https://m-dei.vir-gol.ir/admin/category.php?category=server
-- Support name: پشتیبانی
-- Support email: support@vir-gol.ir
# -------==========-------
7 - https://m-dei.vir-gol.ir/admin/settings.php?section=sessionhandling
-- Timeout: 8 Week
# -------==========-------
8 - 
 Logged IP address source : first one
# -------==========-------
# 8- https://m-dei.vir-gol.ir/admin/category.php?category=email
# -- SMTP Auth Type : PLAIN
# - SMTP Hosts = mail.legace.ir:587
# - SMTP username = noreply@legace.ir
# - SMTP password = Mailpass.24
# - SMTP security = tls
# - No-reply address = noreply@legace.ir
# -------==========-------
9 - https://m-dei.vir-gol.ir/admin/settings.php?section=optionalsubsystems
Enable web services 
# Enable statistics 
Enable global search 
# -------==========-------
10- https://m-dei.vir-gol.ir/admin/category.php?category=roles
Hide user fields: unused
Show user identity :  ID number,  Email address
Enable Gravatar: yes
# -------==========-------
11- https://m-dei.vir-gol.ir/admin/settings.php?section=sitepolicies
Force users to log in: yes
Force users to log in to view user pictures : yes
Open to search engines :yes
Allow indexing by search engines : EVERYWHERE
Maximum time to edit posts : 60min
# -------==========-------
12- https://m-dei.vir-gol.ir/admin/settings.php?section=messages
 Notification email override : True

13- https://m-dei.vir-gol.ir/admin/settings.php?section=usermanagement
 Default user filters : Email address
 
# -------==========-------
# 14- Theme setting:
# https://m-dei.vir-gol.ir/admin/settings.php?section=navigation
# Allow guest access to Dashboard: no
# Show course full names : yes
# Course limit : 50
# Use site name for site pages : yes
# Moodle Docs document root : https://support.vir-gol.ir

# https://m-dei.vir-gol.ir/admin/tool/installaddon/index.php
# --install adaptable theme 

# After installation in "New settings - Adaptable settings" set
# Logo, Favicon, Background image & Frontpage Background Image 

# https://m-dei.vir-gol.ir/admin/category.php?category=theme_adaptable
# Paste theme settings in "Import theme settings" box

# https://m-dei.vir-gol.ir/admin/settings.php?section=additionalhtml
#   add in head:
#   <style>
#     .forgetpass {display: none;}
#   </style>
#   <script type="text/javascript">window.$crisp=[];window.CRISP_WEBSITE_ID="4ede6290-1f82-45d7-81ff-1ea74b2afc00";(function(){d=document;s=d.createElement("script");s.src="https://client.crisp.chat/l.js";s.async=1;d.getElementsByTagName("head")[0].appendChild(s);})();</script>

# -------==========-------
# *Custom CSS 

#   #page{
#   background-repeat: no-repeat;
#     background-attachment: fixed;
#   }
#   .block {
#       background: #ffffff80!important;
#   }
#   .block>.header,  {
#       background: #ffffff80;
#   }
#   .block>.content {
#       background: #ffffff80;
#   }
#   .ftco-footer {
#       background: #202442 !important;
#   }
#   .block_online_users .fa-eye {display: none;}
#   .block_online_users .fa-eye {visibility: hidden;}
  
# https://m-dei.vir-gol.ir/theme/index.php
#   Change default Theme to adaptable
  
# -------==========-------
# Testing purpose:
# -------==========-------
1 - https://m-dei.vir-gol.ir/admin/settings.php?section=debugging
# Debug messages : Normal
# Performance info : yes
# -------==========-------
2 - https://m-dei.vir-gol.ir/admin/settings.php?section=licensesettings
 Default site licence : all rights reserved
Todo: 
configure System paths
-- add aspell support --> add persian vocabs