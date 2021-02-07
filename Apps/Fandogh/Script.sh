# -------==========-------
# Fandogh CLI
# -------==========-------
pip install fandogh_cli --upgrade
pip3 install fandogh-cli --upgrade

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