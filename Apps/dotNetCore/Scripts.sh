# -------==========-------
# Install .Net Core
# -------==========-------
# macos
https://github.com/isen-ng/homebrew-dotnet-sdk-versions
brew tap isen-ng/dotnet-sdk-versions
brew install --cask <version>
dotnet --list-sdks

# Ubuntu 16.04
wget https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
# Ubuntu 20.04
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb

# Install the SDK 2.2
sudo apt-get update; \
  sudo apt-get install -y apt-transport-https && \
  sudo apt-get update && \
  sudo apt-get install -y dotnet-sdk-2.2

# Install the SDK 3.1
sudo apt-get update; \
  sudo apt-get install -y apt-transport-https && \
  sudo apt-get update && \
  sudo apt-get install -y dotnet-sdk-3.1

# Install the SDK 5.0
sudo apt-get update; \
  sudo apt-get install -y apt-transport-https && \
  sudo apt-get update && \
  sudo apt-get install -y dotnet-sdk-5.0

# Install the runtime
sudo apt-get update; \
  sudo apt-get install -y apt-transport-https && \
  sudo apt-get update && \
  sudo apt-get install -y aspnetcore-runtime-3.1


dotnet run --urls=http://localhost:5001/
# -------==========-------
# Linux Service
# -------==========-------
sudo su
dotnet publish -c release -o /var/www/webHook
cat <<EOF > /etc/systemd/system/kestrel-webHook.service
[Unit]
Description=.NET Web API for IoT Webhook

[Service]
WorkingDirectory=/var/www/webHook
#ExecStart=dotnet run --urls http://0.0.0.0:5000/
ExecStart=/usr/bin/dotnet /var/www/webHook/webHookApi.dll --urls http://0.0.0.0:55000/
Restart=always
# Restart service after 10 seconds if the dotnet service crashes:
RestartSec=10
KillSignal=SIGINT
SyslogIdentifier=dotnet-webHook
#User=www-data
User=root
Environment=ASPNETCORE_ENVIRONMENT=Production
Environment=DOTNET_PRINT_TELEMETRY_MESSAGE=false

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable kestrel-webHook.service
sudo systemctl start kestrel-webHook.service
sudo systemctl stop kestrel-webHook.service
sudo systemctl restart kestrel-webHook.service
sudo systemctl status kestrel-webHook.service
sudo journalctl -fu kestrel-webHook.service
systemctl daemon-reload

# -------==========-------
# Docker
# -------==========-------
# Build
git pull
docker build -t goldenstarc/virgol:1.3.5 .
docker login
docker tag  goldenstarc/virgol:1.3.5  goldenstarc/virgol:latest
docker push goldenstarc/virgol:1.3.5
docker push goldenstarc/virgol:latest

# Runn
docker pull goldenstarc/virgol:latest
docker stop virgol
docker rm virgol

docker run \
    -p 5001:80 \
    -v VirgolExcels:/app/BulkData \
    --restart=always \
    --name=virgol \
    -e "ASPNETCORE_URLS=http://+" \
    -e "ASPNETCORE_ENVIRONMENT=Production" \
    -e "VIRGOL_SERVER_ROOT_URL=http://lms.legace.ir" \
    -e "VIRGOL_DATABASE_TYPE=postgres" \
    -e "VIRGOL_DATABASE_HOST=db.legace.ir" \
    -e "VIRGOL_DATABASE_NAME=LMS" \
    -e "VIRGOL_DATABASE_USER=postgres" \
    -e "VIRGOL_DATABASE_PASSWORD=PostgreSQLpass.24" \
    -e "VIRGOL_MODDLE_COURSE_URL=https://moodle/course/view.php?id=" \
    -e "VIRGOL_MOODLE_BASE_URL=https://moodle/webservice/rest/server.php?moodlewsrestformat=json" \
    -e "VIRGOL_MOODLE_TOKEN=616ed6bc394212692b03ea59b7f94670" \
    -e "VIRGOL_FARAZAPI_URL=http://rest.ippanel.com" \
    -e "VIRGOL_FARAZAPI_SENDER_NUMBER=+98500010707" \
    -e "VIRGOL_FARAZAPI_USERNAME=goldenstarc" \
    -e "VIRGOL_FARAZAPI_PASSWORD=hektug-fakbAm-0vypje" \
    -e "VIRGOL_FARAZAPI_API_KEY=qcP4IQp3PPRV3ppvkG9ScHJcwvUPL3iOJrV9n7QiqDA=" \
    -e "VIRGOL_BBB_BASE_URL=https://b1.legace.ir/bigbluebutton/api/" \
    -e "VIRGOL_BBB_SECRET=1b6s1esKbXNM82ussxx8OHJTenNvfkBu59tkHHADvqk" \
    -e "VIRGOL_BBB_CALLBACK_URL=/meetingResponse/" \
    -e "VIRGOL_JWT_SECRET=Saleh Secret Key" \
    -e "VIRGOL_LDAP_SERVER=ldap.legace.ir" \
    -e "VIRGOL_LDAP_PORT=389" \
    -e "VIRGOL_LDAP_USER_ADMIN=cn=admin,dc=legace,dc=ir" \
    -e "VIRGOL_LDAP_PASSWORD=OpenLDAPpass.24" \
    -d goldenstarc/virgol:1.3.5
# -------==========-------
# Payanak
# -------==========-------
docker build -t goldenstarc/payanak:1.0 .
docker build -t goldenstarc/payanak:2.0 .

docker run \
    --name payanak_1.0 \
    -p 5000:80 \
    --restart=always \
    -d goldenstarc/payanak

docker run \
    --name payanak_2.0 \
    -p 5000:80 \
    --restart=always \
    -d goldenstarc/payanak-v2.0
# -------==========-------
# Dotnet Commands:
# -------==========-------
dotnet run --launch-profile ASPNET_Core_2_1

PublishConnection

dotnet run --environment Development
dotnet run --environment Production
dotnet run --environment Staging

dotnet run --urls http://localhost:8080/

export ASPNETCORE_ENVIRONMENT=Production
dotnet run --urls http://localhost:5000/ --environment Development
dotnet run --urls http://localhost:5000/ --environment Production
dotnet run --urls http://localhost:5000/ --environment Staging

.NET RID Catalog
https://docs.microsoft.com/en-us/dotnet/core/rid-catalog

https://docs.microsoft.com/en-us/dotnet/core/rid-catalog#linux-rids
dotnet publish -c release -o ./release/linux-x64
dotnet publish -c release -o ./release/linux-x64 -r linux-x64 --self-contained false

https://docs.microsoft.com/en-us/dotnet/core/rid-catalog#macos-rids
dotnet publish -c release -o ./release/osx-x64 -r osx.10.14-x64 --self-contained false
dotnet publish -c release -o ./release/osx-x64 -r osx.11.0-x64 --self-contained false

# -------==========-------
# add sln
# -------==========-------
mkdir src
cd src
dotnet new sln --name artan-gym
dotnet sln add ./artan-gym.csproj
dotnet restore
dotnet build artan-gym.sln
# -------==========-------
# Common Errors:
# -------==========-------
echo fs.inotify.max_user_instances=524288 | tee -a /etc/sysctl.conf && sysctl -p

https://dev.to/jaceromri/dynamic-api-url-for-your-frontend-project-using-docker-39n0