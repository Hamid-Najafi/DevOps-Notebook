# -------==========-------
# Watchtower
# -------==========-------
https://containrrr.dev/watchtower/

docker run -d \
    --name watchtower \
    -v /var/run/docker.sock:/var/run/docker.sock \
    containrrr/watchtower

# -------==========-------
# Label Only
# -------==========-------
# Run command
containrrr/watchtower --label-enable
# --label-enable only containers with com.centurylinklabs.watchtower.enable=true are considered for the remaining filters 