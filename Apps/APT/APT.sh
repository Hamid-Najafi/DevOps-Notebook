# -------==========-------
# APT Proxy
# -------==========-------

cat >>  /etc/apt/apt.conf << EOF
Acquire::http::Proxy "http://172.25.10.21:10809";
Acquire::https::Proxy "http://172.25.10.21:10809";
EOF

cat >>  /etc/apt/apt.conf << EOF
Acquire::http::Proxy "http://Proxy.Docker.ir:5555";
EOF

# -------==========-------
# Apt Repository
# -------==========-------
# BEST WAY
# https://docker-registry.ir
sudo su
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
# -------==========-------
# repos.um.ac.ir
http://rpm.um.ac.ir

sudo nano /etc/apt/sources.list
# Ubuntu 16.04 (Xenial Xerus) 
# support until April 2021
deb http://repos.um.ac.ir/ubuntu/ xenial main restricted universe multiverse 
deb http://repos.um.ac.ir/ubuntu/ xenial-updates main restricted universe multiverse 
deb http://repos.um.ac.ir/ubuntu/ xenial-security main restricted universe multiverse

# Ubuntu 18.04 (Bionic Beaver) 
# support until April 2023
deb http://repos.um.ac.ir/ubuntu/ bionic main restricted universe multiverse 
deb http://repos.um.ac.ir/ubuntu/ bionic-updates main restricted universe multiverse 
deb http://repos.um.ac.ir/ubuntu/ bionic-security main restricted universe multiverse

# Ubuntu 20.04 (Focal Fossa) 
# support until April 2025
deb http://repos.um.ac.ir/ubuntu/ focal main restricted universe multiverse 
deb http://repos.um.ac.ir/ubuntu/ focal-updates main restricted universe multiverse 
deb http://repos.um.ac.ir/ubuntu/ focal-security main restricted universe multiverse

# 0-1.IR
# Ubuntu 19.04 (Disco Xerus)
deb http://mirror.0-1.cloud/ubuntu/ disco main restricted
deb-src http://mirror.0-1.cloud/ubuntu/ disco main restricted


sudo apt-get update