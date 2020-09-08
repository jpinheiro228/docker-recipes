FROM ubuntu:20.04

EXPOSE 1194/UDP

RUN apt update && apt dist-upgrade -y && \
    LC_ALL=C DEBIAN_FRONTEND=noninteractive apt install -y openvpn easy-rsa && \
    rm -rf /var/lib/apt/lists/*

COPY server.conf /etc/openvpn/server
COPY create-ca.sh create-vpn-server-certs.sh init.sh make-client.sh base.conf /root/

VOLUME ["/etc/openvpn/server", "/root/clients", "/root/certificates"] 

