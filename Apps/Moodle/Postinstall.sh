# -------==========-------
# Customized Moodle
# -------==========-------
# Admin page
https://moodle.legace.ir/admin/search.php
# -------==========-------
1- Add Persian lang:
https://moodle.legace.ir/admin/tool/langimport/index.php

https://moodle.legace.ir/admin/settings.php?section=langsettings
-- Language autodetect = no
-- Default language = فارسی

# -------==========-------
2- Add Persian Cal & set to default
https://moodle.legace.ir/admin/tool/installaddon/index.php
--install Persian Cal 

https://moodle.legace.ir/admin/settings.php?section=calendar
Calendar type : persian
Admins see all : true
Time display format : 12h
Start of week : saturday
Weekend days :Thursday, friday
# -------==========-------
3- Theme setting:
https://moodle.legace.ir/admin/settings.php?section=navigation
Allow guest access to Dashboard: no
Show course full names : yes
Course limit : 50
Use site name for site pages : yes
Moodle Docs document root : https://support.legace.ir

https://moodle.legace.ir/admin/tool/installaddon/index.php
--install adaptable theme 

https://moodle.legace.ir/admin/category.php?category=theme_adaptable
--set Customize the header of this theme. See the layout here --> Logo
--set Customize the header of this theme. See the layout here -->Favicon

https://moodle.legace.ir/admin/settings.php?section=theme_adaptable_layout
--set Control aspects of the sites layout -->  Frontpage Background Image 

https://moodle.legace.ir/admin/settings.php?section=theme_adaptable_login
--set Customize the login page --> Background image 
# -------==========-------
4- Set Location, Country:
https://moodle.legace.ir/admin/settings.php?section=locationsettings
# -------==========-------
5-  GeoLite2 City MaxMind DB 
docker exec -it moodle_moodle_1 mkdir /bitnami/moodledata/geoip/ 
docker cp ~/GeoLite2-City.mmdb moodle_moodle_1:/bitnami/moodledata/geoip/GeoLite2-City.mmdb  
# -------==========-------
6- Front page settings 
https://moodle.legace.ir/admin/settings.php?section=frontpagesettings
# -------==========-------
7-https://moodle.legace.ir/admin/settings.php?section=manageauths
-- Guest login button = Hide
-- Limit concurrent logins  = 1
-- Forgotten password URL = https://lms.legace.ir/
-- Allow log in via email : true
-- Prevent account creation when authenticating : true
-- Autofocus login page form : true
-- Allowed email domains : legace.ir
-- Disable Email-based self-registration
-- Enable LDAP server
# -------==========-------
8- https://moodle.legace.ir/admin/settings.php?section=manageantiviruses
-- ClamAV antivirus: Enable
# -------==========-------
9- https://moodle.legace.ir/admin/category.php?category=server
-- Support name: پشتیبانی
-- Support email: admin@legace.ir
-- Support page : support.legace.ir
# -------==========-------
10- https://moodle.legace.ir/admin/settings.php?section=sessionhandling
-- Timeout: 4 Week
# -------==========-------
11- 
 Logged IP address source : first one
# -------==========-------
13- https://moodle.legace.ir/admin/category.php?category=email
 Bitnami handles this but:
-- SMTP Auth Type : PLAIN
# -------==========-------
14- https://moodle.legace.ir/admin/settings.php?section=optionalsubsystems
Enable web services 
Enable statistics 
Enable global search 
# -------==========-------
15- https://moodle.legace.ir/admin/category.php?category=roles
Hide user fields: unused
Show user identity :  ID number,  Email address
Enable Gravatar: yes
# -------==========-------
16- https://moodle.legace.ir/admin/settings.php?section=sitepolicies
Force users to log in: yes
Force users to log in to view user pictures : yes
Open to search engines :yes
Allow indexing by search engines : EVERYWHERE
Maximum time to edit posts : 60min
# -------==========-------
17- https://moodle.legace.ir/admin/settings.php?section=additionalhtml
add in head:
<style>
  .forgetpass {display: none;}
</style>
<script type="text/javascript">window.$crisp=[];window.CRISP_WEBSITE_ID="4ede6290-1f82-45d7-81ff-1ea74b2afc00";(function(){d=document;s=d.createElement("script");s.src="https://client.crisp.chat/l.js";s.async=1;d.getElementsByTagName("head")[0].appendChild(s);})();</script>

 Custom CSS 

 #page{
background-repeat: no-repeat;
  background-attachment: fixed;
}
.block {
    background: #ffffff80!important;
}
.block>.header,  {
    background: #ffffff80;
}
.block>.content {
    background: #ffffff80;
}
.ftco-footer {
    background: #202442 !important;
}
.block_online_users .fa-eye {display: none;}
.block_online_users .fa-eye {visibility: hidden;}

# -------==========-------
18- https://moodle.legace.ir/admin/settings.php?section=messages
 Notification email override : True

https://moodle.legace.ir/admin/settings.php?section=usermanagement
 Default user filters : Email
# -------==========-------

19 - https://moodle.legace.ir/admin/settings.php?section=authsettingldap
  LDAP server settings
    Host URL : ldap://ldap.legace.ir/
  Bind settings
    Distinguished name : cn=admin,dc=legace,dc=ir
    Password : OpenLDAPpass.24
  User lookup settings
    Context : ou=people,dc=legace,dc=ir
    User attribute : uniqueidentifier
  Data mapping
    Data mapping (First name) : cn
    Update local (First name) : On Every login
    Update external (First name) : Never
    Data mapping (Surname) : sn
    Update local (Surname) : On Every login
    Update external (Surname) : Never
    Data mapping (Email address) : mail
    Update local (Email address) : On Every login
    Update external (Email address) : Never
    Data mapping (ID number) : employeeNumber
    Update local (ID number) : On Every login
    Update external (ID number) : Never
    
20 - https://moodle.legace.ir/admin/search.php?query=enablewebservices
  Enable web Service : true 

21 - https://moodle.legace.ir/admin/settings.php?section=webserviceprotocols
  Enable REST & SOAP Protocol

22 - https://moodle.legace.ir/user/editadvanced.php?id=-1
  Create User for Webservice
  
23 - https://moodle.legace.ir/admin/roles/manage.php
  Define role -> ArchType:Manager then add permission -> webservice:rest

24 - https://moodle.legace.ir/admin/webservice/service.php?id=0
  Create new Service 
     Enabled : true
     Authorised users only  : true

25 - https://moodle.legace.ir/admin/settings.php?section=externalservices
  Add these Functions to Service that Create in previous Part :
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
  Then Add User that create in part 22 into Service from Authorised users 
  
26 - https://moodle.legace.ir/admin/settings.php?section=webservicetokens
  Add new token for Created User in part 22 and service in part 24

27 - https://moodle.legace.ir/admin/tool/installaddon/index.php
  Install BBB Plugin
#Testing purpose:
# -------==========-------
12- https://moodle.legace.ir/admin/settings.php?section=debugging
# Debug messages : Normal
# Performance info : yes
# -------==========-------
13- https://moodle.legace.ir/admin/settings.php?section=licensesettings
 Default site licence : all rights reserved
Todo: 
configure System paths
-- add aspell support --> add persian vocabs