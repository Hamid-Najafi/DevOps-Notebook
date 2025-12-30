# -------==========-------
# Mattermost Docker Compose
# -------==========-------

# Clone mattermost Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/1.OperatingSystems/1.Ubuntu/Mattermost ~/docker/mattermost
cd ~/docker/mattermost

# Make mattermost Directory
sudo mkdir -p /mnt/data/mattermost/mattermost-config
sudo mkdir -p /mnt/data/mattermost/mattermost-data
sudo mkdir -p /mnt/data/mattermost/mattermost-logs
sudo mkdir -p /mnt/data/mattermost/mattermost-plugins
sudo mkdir -p /mnt/data/mattermost/mattermost-client-plugins
sudo mkdir -p /mnt/data/mattermost/mattermost-bleve-indexes
sudo mkdir -p /mnt/data/mattermost/postgres

# Set Permissions
Confluene is on UID 2000
Postgresis is on UID 70

docker exec -it mattermost id
docker exec -it mattermost-postgres id postgres

sudo chmod 750 -R /mnt/data/mattermost
sudo chown -R 2000:2000 /mnt/data/mattermost/mattermost-*
sudo chown -R 999:999 /mnt/data/mattermost/postgres


# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/mattermost/mattermost-config \
      --opt o=bind mattermost-config

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/mattermost/mattermost-data \
      --opt o=bind mattermost-data

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/mattermost/mattermost-logs \
      --opt o=bind mattermost-logs

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/mattermost/mattermost-plugins \
      --opt o=bind mattermost-plugins

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/mattermost/mattermost-client-plugins \
      --opt o=bind mattermost-client-plugins

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/mattermost/mattermost-bleve-indexes \
      --opt o=bind mattermost-bleve-indexes

docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/mattermost/postgres \
      --opt o=bind mattermost-postgres

# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker network create mattermost-network
docker compose pull
docker compose up -d

mattermost channel list --team c1tech

# -------==========-------
# Authentik Integrations
# -------==========-------
https://integrations.goauthentik.io/chat-communication-collaboration/mattermost-team-edition/
# Create Two Scoper for username and id
sudo nano /mnt/data/mattermost/mattermost-config/config.json
    "GitLabSettings": {
        "Enable": true,
        "Secret": "",
        "Id": "",
        "Scope": "",
        "AuthEndpoint": "https://auth.c1tech.group/application/o/authorize/",
        "TokenEndpoint": "https://auth.c1tech.group/application/o/token/",
        "UserAPIEndpoint": "https://auth.c1tech.group/application/o/userinfo/",
        "DiscoveryEndpoint": "https://auth.c1tech.group/application/o/mattermost/.well-known/openid-configuration",
        "ButtonText": "Log in with authentik",
        "ButtonColor": "#000000"
    },

docker restart mattermost
docker logs mattermost -f
sudo chmod 700 /mnt/data/mattermost/mattermost-config/config.json 
# -------==========-------
# [PLUGINS]
# -------==========-------
https://github.com/mattermost/mattermost-plugin-confluence

https://github.com/mattermost/mattermost-plugin-metrics
https://github.com/mattermost/mattermost-plugin-antivirus
# -------==========-------
# config.json
# -------==========-------
# https://docs.mattermost.com/guides/get-started-with-administration.html
sudo nano /mnt/data/mattermost/mattermost-config/config.json
docker restart mattermost
docker logs mattermost -f

# -------==========-------
# JIRA [PLUGINS]
# -------==========-------
https://github.com/mattermost/mattermost-plugin-jira
1. Add OAuth 
2. Add Webhook for whole JIRA
3. add Webhook subscribe for channel (using /jira subscribe edit)
/jira subscribe edit
# -------==========-------
# GITLAB [PLUGINS]
# -------==========-------
https://github.com/mattermost/mattermost-plugin-gitlab
1. Add OAuth
2. connect gitlab account to mattermost
2. Add Webhook for every single channel to every repo you want (using /gitlab subscriptions)

/gitlab connect
/gitlab subscriptions add group[/project]
/gitlab webhook add group[/project]
/gitlab subscriptions list
# Defaults to "merges,issues,tag"
/gitlab subscriptions add software-group/control-panel merges,issues,tag,pushes,jobs,issue_comments
# -------==========-------
# Call [PLUGIN] config.json
# -------==========-------
# https://docs.mattermost.com/configure/plugins-configuration-settings.html#calls

## Test ports with netcat
Server:
sudo nc -l -p 8443
sudo nc -u -l -p 8443

Client:
nc c1tech.group 8443
nc -u c1tech.group  8443

ICE Servers Configurations:
see coturn/coturn.sh

[{"urls":["stun:meet-jit-si-turnrelay.jitsi.net:443"]},{"urls":["turn:my.turnserver.com:443?transport=tcp"]}]
[{"urls":["stun:turn.c1tech.group:3478"]},{"urls":["turn:turn.c1tech.group:3478?transport=udp"], "username":"webrtc","credential":"coturnpass.24"}]
[{"urls":["stun:turn.c1tech.group:5349"]},{"urls":["turn:turn.c1tech.group:5349?transport=udp"], "username":"webrtc","credential":"coturnpass.24"}]
[{"urls":["stun:turn.c1tech.group:5349"]},{"urls":["turn:turn.c1tech.group:5349?transport=udp"]}]
# -------==========-------
# Jitsi Plugin (Beta)
# -------==========-------
https://github.com/mattermost/mattermost-plugin-jitsi

# -------==========-------
# MMCTL
# -------==========-------
# https://docs.mattermost.com/manage/mmctl-command-line-tool.html#mmctl-auth-login
docker exec -it mattermost /bin/bash
mmctl auth login https://mm.c1tech.group/  --name c1tech --username admin
mmctl config set ServiceSettings.EnableAPIUserDeletion true
mmctl user delete <USER>
