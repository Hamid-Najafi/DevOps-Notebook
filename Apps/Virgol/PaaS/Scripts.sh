# -------==========-------
# Fanddogh
# -------==========-------
cd ~/DevOps-Notebook/Apps/Virgol/PaaS/
cd /Users/hamid/Development/Software/DevOps-Notebook/Apps/Virgol/PaaS
fandogh login --username goldenstarc --password myzsyn-fucjys-0motjI
fandogh namespace active --name goldenstarc
fandogh namespace active --name hamid-najafi
fandogh service apply -f virgol-fandogh-manifests.yml
fandogh service apply -f rd-fandogh-manifests.yml

# -------==========-------
# CI/CD
# -------==========-------
fandogh secret create  \
  --name gitlab-cred-virgol \
  -t docker-registry \
  -f server=registry.gitlab.com \
  -f username=fandogh \
  -f password=s4ZsgNDo2QqC46CvGx_z

# -------==========-------
# Commands
# -------==========-------
fandogh exec --service phpldapadmin "bash" -i
      volume_name: volume
  volume_browser_enabled: truev