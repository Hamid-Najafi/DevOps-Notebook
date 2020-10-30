Clustered BBB:
BigBlueButton Exporter
    https://bigbluebutton-exporter.greenstatic.dev/installation/bigbluebutton_exporter/

Single BBB:
All-In-One Monitoring Stack 
    https://bigbluebutton-exporter.greenstatic.dev/installation/all_in_one_monitoring_stack/
# -------==========-------
# Monitoring: BBB Exporter
# -------==========-------
cd ~/devops-notebook/Apps/BigBlueButton/Monitoring/bbb-exporter/
# 1. Fill secret.env
bbb-conf --secret 
sudo nano secrets.env
# 2. Run BBB Exporter
sudo docker-compose up -d
# 3. Create HTTP basic auth password for exporter (with prometheus connects to)
# Username: metrics, Password: monitor@bbb
sudo apt-get install apache2-utils
sudo htpasswd -c /etc/nginx/.htpasswd metrics
# 4. Add Nginx site configuration
sudo nano /etc/nginx/sites-available/bigbluebutton
# BigBlueButton Exporter (metrics)
location /metrics/ {
    auth_basic "BigBlueButton Exporter";
    auth_basic_user_file /etc/nginx/.htpasswd;
    proxy_pass http://127.0.0.1:9688/;
    include proxy_params;

}
# 5. Reload nginx
sudo nginx -t
sudo systemctl reload nginx
# 6. Add the exporter to your Prometheus configuration
(Its there in my Prometheus Setup)
- job_name: 'bbb'
  scrape_interval: 5s
  scheme: https
  basic_auth:
    username: "<HTTP BASIC AUTH USERNAME>"
    password: "<HTTP BASIC AUTH PASSWORD>"
  static_configs:
  - targets: ['example.com']

# Check metrics on:
https://bbb.legace.ir/metrics/