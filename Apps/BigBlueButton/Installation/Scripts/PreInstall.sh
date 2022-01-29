#!/bin/bash

echo "--------------------------"
echo "Disable Ubuntu Automatic Update"
echo "--------------------------"
sed -i 's/Prompt=lts/Prompt=never/g' /etc/update-manager/release-upgrades

# echo "--------------------------"
# echo "Setting HTTP Proxy"
# echo "--------------------------"
# echo -e "http_proxy=http://admin:Squidpass.24@hr.hamid-najafi.ir:3128/\nhttps_proxy=http://admin:Squidpass.24@hr.hamid-najafi.ir:3128/" | sudo tee -a /etc/environment

echo "--------------------------"
echo "Setting APT Sources List"
echo "--------------------------"
mv /etc/apt/sources.list /etc/apt/sources.list-back
cat > /etc/apt/sources.list <<EOF
deb http://a.docker-registry.ir/ubuntu/ $(lsb_release -cs) main restricted universe multiverse
deb-src http://a.docker-registry.ir/ubuntu/ $(lsb_release -cs) main restricted  universe multiverse
deb http://a.docker-registry.ir/ubuntu/ $(lsb_release -cs)-updates main restricted universe multiverse
deb-src http://a.docker-registry.ir/ubuntu/ $(lsb_release -cs)-updates main restricted universe multiverse
deb http://a.docker-registry.ir/ubuntu/ $(lsb_release -cs)-backports main restricted universe multiverse
deb-src http://a.docker-registry.ir/ubuntu/ $(lsb_release -cs)-backports main restricted universe multiverse
deb http://a.docker-registry.ir/ubuntu/ $(lsb_release -cs)-security main restricted universe multiverse
deb-src http://a.docker-registry.ir/ubuntu/ $(lsb_release -cs)-security main restricted universe multiverse
EOF

echo "--------------------------"
echo "Installing Usefull apps"
echo "--------------------------"
sudo apt update
sudo apt install -y bmon ncdu

echo "--------------------------"
echo "Setting Docker Proxy"
echo "--------------------------"
sudo mkdir -p /etc/systemd/system/docker.service.d
cat >> /etc/systemd/system/docker.service.d/http-proxy.conf << EOF
[Service]
Environment="HTTP_PROXY=http://admin:Squidpass.24@hr.hamid-najafi.ir:3128"
Environment="HTTPS_PROXY=http://admin:Squidpass.24@hr.hamid-najafi.ir:3128"
Environment="NO_PROXY=localhost,127.0.0.1,docker-registry.example.com,.corp"
EOF

echo "--------------------------"
echo "Setting APT Proxy"
echo "--------------------------"
cat >> /etc/apt/apt.conf.d/proxy.conf << EOF
Acquire::http::Proxy "http://admin:Squidpass.24@hr.hamid-najafi.ir:3128";
Acquire::https::Proxy "http://admin:Squidpass.24@hr.hamid-najafi.ir:3128";
EOF

echo "--------------------------"
echo "Verify Proxy"
echo "--------------------------"
curl -x http://admin:Squidpass.24@hr.hamid-najafi.ir:3128/ -L http://panel.vir-gol.ir

echo "Done!"
