#!/bin/bash

# Setting up OpenVPN server on the same machine as CA

EASYRSA_DIR=/root/certificates

if [ -z "$(dpkg -l |grep openvpn)" ]; then
    apt update && apt install -y openvpn && rm -rf /var/lib/apt/lists/*
fi

cd $EASYRSA_DIR
./easyrsa --batch --req-cn="VPN SERVER" gen-req server nopass
./easyrsa --batch sign-req server server
openvpn --genkey --secret ta.key

cp $EASYRSA_DIR/pki/private/server.key /etc/openvpn/server/
cp $EASYRSA_DIR/pki/issued/server.crt /etc/openvpn/server/
cp $EASYRSA_DIR/pki/ca.crt /etc/openvpn/server/
cp $EASYRSA_DIR/ta.key /etc/openvpn/server/

sed -i "s/.*net.ipv4.ip_forward.*/net.ipv4.ip_forward = 1/" /etc/sysctl.conf
sysctl -p
