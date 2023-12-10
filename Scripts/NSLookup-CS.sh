#!/usr/bin/env bash

1. How to find the A record of а domain.
Command line:
$ nslookup c1tech.local
example.com

2. How to check the NS records of a domain.
Command line:
$nslookup -type=ns example.com

3. How to query the SOA record of a domain.
Command line:
$nslookup -type=soa example.com

4. How to find the MX records responsible for the email exchange.
Command line:
$ nslookup -query=mx example.com

5. How to find all of the available DNS records of a domain.
Command line:
$ nslookup -type=any c1tech.local
example.com

6. How to check the using of a specific DNS Server.
Command line:
$ nslookup example.com ns1.nsexample.com

7. How to check the Reverse DNS Lookup.
Command line:
$ nslookup 10.20.30.40

8. How to change the port number for the connection.
Command line:
$ nslookup -port=56 example.com

9.How to change the timeout interval for a reply.
Command line:
$ nslookup -timeout=20 example.com

10. How to enable debug mode.
Debug mode provides important and detailed information both for the question and for the received answer.

Command line:
$ nslookup -debug example.com