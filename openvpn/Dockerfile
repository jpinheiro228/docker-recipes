FROM ubuntu:20.04

EXPOSE 1194/UDP

RUN apt update && apt dist-upgrade -y

RUN LC_ALL=C DEBIAN_FRONTEND=noninteractive apt install -y openvpn easy-rsa && \
    rm -rf /var/lib/apt/lists/*

COPY server.conf /etc/openvpn/server

#To ensure persistance of the configuration files, we use volumes.
#Mount them with -v flag.
VOLUME ["/etc/openvpn/server", "/root/clients", "/root/certificates"] 

