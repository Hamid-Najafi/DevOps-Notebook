# -------==========-------
# Fandogh CLI
# -------==========-------
# Install Python
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.8
sudo apt install python3-pip

# Install Fandogh CLI
pip3 install fandogh-cli --upgrade

# Reload Shell and login to Fandogh
fandogh login --username goldenstarc --password myzsyn-fucjys-0motjI

fandogh namespace active --name goldenstarc
fandogh namespace active --name hamid-najafi

cd ~/DevOps-Notebook/Apps/Virgol/PaaS/
cd /Users/hamid/Development/Software/DevOps-Notebook/Apps/Virgol/PaaS

fandogh service apply -f virgol-fandogh-manifests.yml
fandogh service apply -f rd-fandogh-manifests.yml

fandogh parameter are passed with : -c NAME=VALUE

# -------==========-------
# Run Commands
# -------==========-------
fandogh exec --service phpldapadmin "bash" -i
      volume_name: volume
  volume_browser_enabled: truev
