<?php
$CONFIG = array (
  'htaccess.RewriteBase' => '/',
  'memcache.local' => '\\OC\\Memcache\\APCu',
  'apps_paths' => 
  array (
    0 => 
    array (
      'path' => '/var/www/html/apps',
      'url' => '/apps',
      'writable' => false,
    ),
    1 => 
    array (
      'path' => '/var/www/html/custom_apps',
      'url' => '/custom_apps',
      'writable' => true,
    ),
  ),
  'memcache.distributed' => '\\OC\\Memcache\\Redis',
  'memcache.locking' => '\\OC\\Memcache\\Redis',
  'redis' => 
  array (
    'host' => 'redis',
    'password' => 'FuWE1YCAik2gJwvPRvWA',
    'port' => 6379,
  ),
  'overwritehost' => 'nc.c1tech.group',
  'overwriteprotocol' => 'https',
  'overwrite.cli.url' => 'https://nc.c1tech.group',
  'upgrade.disable-web' => true,
  'passwordsalt' => '2wFV//GXDWDYfUHqnulzepJDRKfeup',
  'secret' => 'VTVOl86iKapaoOLyt3HJny2N16xOa3/fouEHOQfJLYYO3Fh3',
  'trusted_domains' => 
  array (
    0 => 'localhost',
    1 => 'nc.c1tech.group',
  ),

  'datadirectory' => '/var/www/html/data',
  'dbtype' => 'pgsql',
  'version' => '31.0.7.1',
  'dbname' => 'nextclouddb',
  'dbhost' => 'postgres',
  'dbtableprefix' => 'oc_',
  'dbuser' => 'oc_admin',
  'dbpassword' => 'DQ7aLT1p3l8BukvhmJvkslReKOOMzl',
  'installed' => true,
  'instanceid' => 'ocxrdc0i375a',
);
