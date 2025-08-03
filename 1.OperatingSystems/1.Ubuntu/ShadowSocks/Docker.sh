# -------==========-------
# ShadowSocks
# -------==========-------
docker pull shadowsocks/shadowsocks-libev
docker run -e PASSWORD=<password> -p<server-port>:8388 -p<server-port>:8388/udp -d shadowsocks/shadowsocks-libev
docker run -e PASSWORD=Shadowpass.24 -e encrypt_method=aes-256-gcm -e --fast-open -p8388:8388 -p8388:8388/udp -d shadowsocks/shadowsocks-libev

docker run -e PASSWORD=Shadowpass.24 -e encrypt_method=aes-256-gcm -e --fast-open -p8288:8388 -p8288:8388/udp -d shadowsocks/shadowsocks-libev

# -------==========-------
# ShadowSocks Client
# -------==========-------
sudo snap install shadowsocks-libev

ss-[local|redir|server|tunnel|manager]

   -s <server_host>           Host name or IP address of your remote server.

   -p <server_port>           Port number of your remote server.

   -l <local_port>            Port number of your local server.

   -k <password>              Password of your remote server.

   -m <encrypt_method>        Encrypt method: rc4-md5,
                              aes-128-gcm, aes-192-gcm, aes-256-gcm,
                              aes-128-cfb, aes-192-cfb, aes-256-cfb,
                              aes-128-ctr, aes-192-ctr, aes-256-ctr,
                              camellia-128-cfb, camellia-192-cfb,
                              camellia-256-cfb, bf-cfb,
                              chacha20-ietf-poly1305,
                              xchacha20-ietf-poly1305,
                              salsa20, chacha20 and chacha20-ietf.
                              The default cipher is chacha20-ietf-poly1305.

   [-a <user>]                Run as another user.

   [-f <pid_file>]            The file path to store pid.

   [-t <timeout>]             Socket timeout in seconds.

   [-c <config_file>]         The path to config file.

   [-n <number>]              Max number of open files.

   [-i <interface>]           Network interface to bind.
                              (not available in redir mode)

   [-b <local_address>]       Local address to bind.
                              For servers: Specify the local address to use 
                              while this server is making outbound 
                              connections to remote servers on behalf of the
                              clients.
                              For clients: Specify the local address to use 
                              while this client is making outbound 
                              connections to the server.

   [-u]                       Enable UDP relay.
                              (TPROXY is required in redir mode)

   [-U]                       Enable UDP relay and disable TCP relay.
                              (not available in local mode)

   [-L <addr>:<port>]         Destination server address and port
                              for local port forwarding.
                              (only available in tunnel mode)

   [-6]                       Resolve hostname to IPv6 address first.

   [-d <addr>]                Name servers for internal DNS resolver.
                              (only available in server mode)

   [--reuse-port]             Enable port reuse.

   [--fast-open]              Enable TCP fast open.
                              with Linux kernel > 3.7.0.
                              (only available in local and server mode)

   [--acl <acl_file>]         Path to ACL (Access Control List).
                              (only available in local and server mode)

   [--manager-address <addr>] UNIX domain socket address.
                              (only available in server and manager mode)

   [--mtu <MTU>]              MTU of your network interface.

   [--mptcp]                  Enable Multipath TCP on MPTCP Kernel.

   [--no-delay]               Enable TCP_NODELAY.

   [--executable <path>]      Path to the executable of ss-server.
                              (only available in manager mode)

   [-D <path>]                Path to the working directory of ss-manager.
                              (only available in manager mode)

   [--key <key_in_base64>]    Key of your remote server.

   [--plugin <name>]          Enable SIP003 plugin. (Experimental)

   [--plugin-opts <options>]  Set SIP003 plugin options. (Experimental)

   [-v]                       Verbose mode.