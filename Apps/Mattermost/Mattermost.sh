# -------==========-------
# Mattermost Docker Compose
# -------==========-------
# Make mattermost Directory
sudo mkdir -p /mnt/data/mattermost/mattermost-config
sudo mkdir -p /mnt/data/mattermost/mattermost-data
sudo mkdir -p /mnt/data/mattermost/mattermost-logs
sudo mkdir -p /mnt/data/mattermost/mattermost-plugins
sudo mkdir -p /mnt/data/mattermost/mattermost-client-plugins
sudo mkdir -p /mnt/data/mattermost/mattermost-bleve-indexes
sudo mkdir -p /mnt/data/mattermost/postgres

# Set Permissions
sudo chmod 770 -R /mnt/data/mattermost/mattermost-config
sudo chown -R 2000:2000 /mnt/data/mattermost/
sudo chown -R 2000:2000 /mnt/data/mattermost/mattermost-config
sudo chown -R 70:70 /mnt/data/mattermost/postgres

# WHAT THE ?!
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
      
# Clone mattermost Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/Apps/mattermost ~/docker/mattermost
cd ~/docker/mattermost

# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker network create mattermost-network
docker compose up -d

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
/mnt/data/mattermost/mattermost-config/config.json
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
# CALL PLUGIN config.json
# -------==========-------
# https://docs.mattermost.com/configure/plugins-configuration-settings.html#calls

"com.mattermost.calls": {
    "allowenablecalls": true,
    "defaultenabled": false,
    "icehostoverride": "mm.c1tech.group",
    "iceservers": "stun:stun.global.calls.mattermost.com:3478",
    "maxcallparticipants": 0,
    "rtcdserviceurl": null,
},


            "com.mattermost.calls": {
                "allowscreensharing": true,
                "defaultenabled": true,
                "enableipv6": false,
                "enablerecordings": false,
                "enableringing": true,
                "enablesimulcast": false,
                "enabletranscriptions": false,
                "icehostoverride": "",
                "iceserversconfigs": "[{\"urls\":[\"stun:stun.global.calls.mattermost.com:3478\"]}]",
                "jobserviceurl": null,
                "maxcallparticipants": 0,
                "maxrecordingduration": 60,
                "recordingquality": "medium",
                "rtcdserviceurl": null,
                "serversideturn": false,
                "tcpserveraddress": "",
                "tcpserverport": null,
                "transcribermodelsize": "base",
                "turncredentialsexpirationminutes": 1440,
                "turnstaticauthsecret": "",
                "udpserveraddress": "",
                "udpserverport": null
            },

# -------==========-------
# MMCTL
# -------==========-------
# https://docs.mattermost.com/manage/mmctl-command-line-tool.html#mmctl-auth-login
docker exec -it mattermost sh
mmctl auth login https://mm.c1tech.group/  --name c1tech --username admin
mmctl config set ServiceSettings.EnableAPIUserDeletion true
mmctl user delete <USER>