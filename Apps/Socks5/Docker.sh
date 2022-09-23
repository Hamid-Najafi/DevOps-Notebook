# -------==========-------
# Socks5
# -------==========-------
# Start container with proxy
docker run -d --name socks5 -p 1080:1080 -e PROXY_USER=<PROXY_USER> -e PROXY_PASSWORD=<PROXY_PASSWORD> serjs/go-socks5-proxy

docker run -d --name socks5 -p 1080:1080 serjs/go-socks5-proxy

docker run -d --name socks5 -p 1080:1080 -e PROXY_USER=admin -e PROXY_PASSWORD=Socks5pass.24 serjs/go-socks5-proxy

docker run -d --restart=always --name tor-socks-proxy -p 9150:9150/tcp peterdavehello/tor-socks-proxy:latest

# Test running service
curl --socks5 --user <PROXY_USER>:<PROXY_PASSWORD> <docker host ip>:1080 http://ifcfg.co

curl -s --socks5 admin:Socks5pass.24@eu.legace.ir:1080 http://ifcfg.co
curl -s --socks5 eu.legace.ir:1080 http://ifcfg.co

curl --socks5-hostname su.legace.ir:9150 https://ipinfo.tw/ip
curl --socks5-hostname su.legace.ir:1080 https://ipinfo.tw/ip
curl --socks5-hostname 127.0.0.1:9150 https://ipinfo.tw/ip
curl --socks5-hostname 127.0.0.1:9150 https://ipinfo.io/ip
curl --socks5-hostname 127.0.0.1:9150 https://icanhazip.com
curl --socks5-hostname 127.0.0.1:9150 https://ipecho.net/plain

docker run --rm curlimages/curl:7.65.3 -s --socks5 <PROXY_USER>:<PROXY_PASSWORD>@<docker host ip>:1080

docker run --rm curlimages/curl:7.65.3 --socks5-hostname eu.legace.ir:1080 https://ipinfo.tw/ip
docker run --rm curlimages/curl:7.65.3 -s --socks5 admin:Socks5pass.24@su.legace.ir:1080 http://ifcfg.co
docker run --rm curlimages/curl:7.65.3 -x socks5h://admin:Socks5pass.24@su.legace.ir:1080 http://ifcfg.co
 $ curl --socks5-hostname 127.0.0.1:9150 https://ipinfo.tw/ip
 $ curl --socks5-hostname 127.0.0.1:9150 https://ipinfo.io/ip
 $ curl --socks5-hostname 127.0.0.1:9150 https://icanhazip.com
 $ curl --socks5-hostname 127.0.0.1:9150 https://ipecho.net/plain
 docker run -d --restart=always --name tor-socks-proxy -p 127.0.0.1:9150:9150/tcp peterdavehello/tor-socks-proxy:latest

# -------==========-------
# Socks5 Over TLS
# -------==========-------