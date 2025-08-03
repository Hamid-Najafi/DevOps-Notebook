# -------==========-------
# Telegram MTProto
# -------==========-------

# Clone repository
mkdir -p ~/docker/mtprotoproxy
git clone https://github.com/Hamid-Najafi/mtprotoproxy.git ~/docker/mtprotoproxy

cd ~/docker/mtprotoproxy
# Edit config.env If needed
# nano config.py
# run proxy
docker compose up -d
# show logs and connections info
docker-compose logs

mtprotoproxy    | tg: tg://proxy?server=135.181.252.192&port=8443&secret=dd0123456789abcdef0123456789abcdef
mtprotoproxy    | tg: tg://proxy?server=135.181.252.192&port=8443&secret=ee0123456789abcdef0123456789abcdef7777772e676f6f676c652e636f6d
mtprotoproxy    | tg2: tg://proxy?server=135.181.252.192&port=8443&secret=ddad36e2fa0de7aca0d81c7c152fb06c80
mtprotoproxy    | tg2: tg://proxy?server=135.181.252.192&port=8443&secret=eead36e2fa0de7aca0d81c7c152fb06c807777772e676f6f676c652e636f6d
mtprotoproxy    | tg3: tg://proxy?server=135.181.252.192&port=8443&secret=dd29075bb048ce065adf59cd67afa496e6
mtprotoproxy    | tg3: tg://proxy?server=135.181.252.192&port=8443&secret=ee29075bb048ce065adf59cd67afa496e67777772e676f6f676c652e636f6d
mtprotoproxy    | tg4: tg://proxy?server=135.181.252.192&port=8443&secret=dd0d7eac72cac961d9645f6515cd8c1afd
mtprotoproxy    | tg4: tg://proxy?server=135.181.252.192&port=8443&secret=ee0d7eac72cac961d9645f6515cd8c1afd7777772e676f6f676c652e636f6d
mtprotoproxy    | tg5: tg://proxy?server=135.181.252.192&port=8443&secret=dd8afbf4a2b7260e6b4ee8ee9b4c09c732
mtprotoproxy    | tg5: tg://proxy?server=135.181.252.192&port=8443&secret=ee8afbf4a2b7260e6b4ee8ee9b4c09c7327777772e676f6f676c652e636f6d