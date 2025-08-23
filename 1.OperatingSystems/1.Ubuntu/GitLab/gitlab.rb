# External URL
external_url 'https://gitlab.c1tech.group'

# SSH Port
gitlab_rails['gitlab_shell_ssh_port'] = 22

# Nginx settings
nginx['enable'] = true
nginx['listen_port'] = 80
nginx['listen_https'] = false
nginx['proxy_set_headers'] = {
  'X-Forwarded-Proto' => 'https',
  'X-Forwarded-Ssl' => 'on'
}

# Timezone
gitlab_rails['timezone'] = "Asia/Tehran"

# Database configuration
gitlab_rails['db_adapter'] = "postgresql"
gitlab_rails['db_encoding'] = "unicode"
gitlab_rails['db_host'] = "postgres"
gitlab_rails['db_database'] = "gitlabhq_production"
gitlab_rails['db_username'] = "gitlab"
gitlab_rails['db_password'] = "zkhuneTBFxpgvUrtDaKs9XG"

# Redis
redis['enable'] = true
gitlab_rails['redis_host'] = "redis"
gitlab_rails['redis_port'] = 6379
gitlab_rails['redis_password'] = "zkhuneTBFxpgv"

# SMTP
gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = "mail.c1tech.group"
gitlab_rails['smtp_port'] = 587
gitlab_rails['smtp_user_name'] = "gitlab@c1tech.group"
gitlab_rails['smtp_password'] = "gi8oFBiXLZkWuGobstus"
gitlab_rails['smtp_domain'] = "mail.c1tech.group"
gitlab_rails['smtp_authentication'] = "login"
gitlab_rails['smtp_enable_starttls_auto'] = true
gitlab_rails['smtp_tls'] = false

gitlab_rails['gitlab_email_from'] = "gitlab@c1tech.group"
gitlab_rails['gitlab_email_reply_to'] = "gitlab@c1tech.group"

# Logging
logging['logrotate_frequency'] = "daily"
logging['logrotate_size'] = "100M"
logging['logrotate_rotate'] = 7

# OIDC / Authentik SSO
gitlab_rails['omniauth_allow_single_sign_on'] = ['openid_connect']
gitlab_rails['omniauth_sync_email_from_provider'] = 'openid_connect'
gitlab_rails['omniauth_sync_profile_from_provider'] = ['openid_connect']
gitlab_rails['omniauth_sync_profile_attributes'] = ['email']
gitlab_rails['omniauth_auto_sign_in_with_provider'] = 'openid_connect'
gitlab_rails['omniauth_block_auto_created_users'] = false
gitlab_rails['omniauth_auto_link_user'] = ['openid_connect']

gitlab_rails['omniauth_providers'] = [
  {
    name: 'openid_connect',
    label: 'C1Tech OIDC Login',
    args: {
      name: 'openid_connect',
      scope: ['openid','profile','email'],
      response_type: 'code',
      issuer: 'https://auth.c1tech.group/application/o/gitlab/',
      discovery: true,
      client_auth_method: 'query',
      uid_field: 'preferred_username',
      send_scope_to_token_endpoint: 'true',
      pkce: true,
      client_options: {
        identifier: 'ClientID',
        secret: 'ClientSecret',
        redirect_uri: 'https://gitlab.c1tech.group/users/auth/openid_connect/callback'
      }
    }
  }
]
