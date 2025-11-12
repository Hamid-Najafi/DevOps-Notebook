# -------==========-------
# The Elastic stack (ELK) powered by Docker and Compose.
# It gives you the ability to analyze any data set by using the searching/aggregation capabilities of Elasticsearch and the visualization power of Kibana.
# -------==========-------

https://github.com/deviantony/docker-elk/tree/tls

# Clone repository 
sudo git clone --branch tls https://github.com/deviantony/docker-elk.git && cd docker-elk

# generate X.509 certificates and private keys
sudo docker compose up tls

# Initialize the Elasticsearch users and groups 
sudo docker compose up setup

# generate encryption keys for Kibana 
sudo docker compose up kibana-genkeys


kibana:
  environment:
    SERVER_NAME: kibana.c1tech.group

# start stack components:
docker compose up -d

# Launch the Kibana web UI by opening http://localhost:5601 in a web browser, and use the following credentials to log in:
# user: elastic
# password: changeme

# Cleanup
docker compose --profile=setup down -v



DNS:
elasticsearch A 172.25.10.15
fleet-server A 172.25.10.16

# Fleet Server
# Linux x86_64
curl -L -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-9.1.4-linux-x86_64.tar.gz
tar xzvf elastic-agent-9.1.4-linux-x86_64.tar.gz
cd elastic-agent-9.1.4-linux-x86_64
sudo ./elastic-agent install \
  --fleet-server-es=https://172.25.10.15:9200 \
  --fleet-server-service-token=AAEAAWVsYXN0aWMvZmxlZXQtc2VydmVyL3Rva2VuLTE3NTkzMDU3NTIxNTQ6V3NnX09sZGVUTFc1alJYbUlBNlFFUQ \
  --fleet-server-policy=fleet-server-policy \
  --fleet-server-es-ca-trusted-fingerprint=0c41dee325f05e5f8a51cea3df6cfabeb05b86636b2e665129dec3c250946210 \
  --fleet-server-port=8220 \
  --install-servers

# Install Elastic Agent
# Linux x86_64
curl -L -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-9.1.4-linux-x86_64.tar.gz 
tar xzvf elastic-agent-9.1.4-linux-x86_64.tar.gz
cd elastic-agent-9.1.4-linux-x86_64
sudo ./elastic-agent install --url=https://172.25.10.16:8220 --enrollment-token=OVJCVG5wa0JoTVVQemdRNDJiRTI6VWhENXBURHA5OWZEZFAxbUpWNVNldw== --insecure
# Windows x86_64
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-9.1.4-windows-x86_64.zip -OutFile elastic-agent-9.1.4-windows-x86_64.zip 
Expand-Archive .\elastic-agent-9.1.4-windows-x86_64.zip -DestinationPath .
cd elastic-agent-9.1.4-windows-x86_64
.\elastic-agent.exe install --url=https://172.25.10.16:8220 --enrollment-token=OVJCVG5wa0JoTVVQemdRNDJiRTI6VWhENXBURHA5OWZEZFAxbUpWNVNldw== --insecure
# Windows MSI
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-9.1.4-windows-x86_64.msi -OutFile elastic-agent-9.1.4-windows-x86_64.msi 
.\elastic-agent.msi --% INSTALLARGS="--url=https://fleet-server:8220 --enrollment-token=Q0tmUW5wa0JHc01iU0J1ZjhWd086QVZTbGNjeWh4NHk5YklFcmJNMnRzZw=="