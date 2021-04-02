# -------==========-------
# HTTP
# -------==========-------
docker run -p 6000:80 ealen/echo-server

curl -I --header 'X-ECHO-CODE: 200-300-400-500' vir-gol.ir:5000
curl vir-gol.ir:5000 | jq
curl vir-gol.ir:5000/get\?foo1\=bar1\&foo2\=bar2 | jq


docker run -p 6001:8080 jmalloc/echo-server

35714286