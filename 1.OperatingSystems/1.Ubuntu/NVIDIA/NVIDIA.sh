# -------==========-------
# Installing the NVIDIA Container Toolkit
# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#installing-with-apt
# -------==========-------


# Configure the production repository:
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

# Update the packages list from the repository:
sudo apt-get update
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt install -y nvidia-driver-570 nvidia-utils-570  nvidia-container-toolkit

# Optionally, configure the repository to use experimental packages:
sed -i -e '/experimental/ s/^#//g' /etc/apt/sources.list.d/nvidia-container-toolkit.list

# Install docker with the NVIDIA Container Toolkit packages:
curl -fsSL get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo chown $USER /var/run/docker.sock
sudo usermod -aG docker $USER
newgrp docker
sudo gpasswd -a $USER docker

# Docker Registry
nano /etc/docker/daemon.json
{
  "insecure-registries" : ["https://docker.arvancloud.ir"],
  "registry-mirrors": ["https://docker.arvancloud.ir"],
  "runtimes": {
       "nvidia": {
           "path": "nvidia-container-runtime",
           "runtimeArgs": []
        }
    }
}
sudo systemctl daemon-reload
sudo systemctl restart docker

# Verify
sudo docker run --rm --runtime=nvidia --gpus all ubuntu nvidia-smi