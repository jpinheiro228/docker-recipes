#!/bin/bash

# Create client configuration if CA and VPN Server are on the same server

KEY_DIR=~/clients/keys
OUTPUT_DIR=~/clients/files
BASE_CONFIG=~/base.conf
EASYRSA_DIR=~/certificates

if [[ -f ${EASYRSA_DIR}/pki/reqs/${1}.req ]]; then
    echo "Client already exists. Exiting..."
    exit 0
fi

mkdir -p ${KEY_DIR} ${OUTPUT_DIR}
cd ${EASYRSA_DIR}
./easyrsa --batch --req-cn="${1}" gen-req ${1} nopass
./easyrsa --batch sign-req client ${1}
cp ${EASYRSA_DIR}/pki/private/${1}.key ${KEY_DIR}
cp ${EASYRSA_DIR}/pki/issued/${1}.crt ${KEY_DIR}

if [[ ! -f ${KEY_DIR}/ta.key ]]; then
    cp ${EASYRSA_DIR}/ta.key ${KEY_DIR}
fi

if [[ ! -f ${KEY_DIR}/ca.key ]]; then
    cp ${EASYRSA_DIR}/pki/ca.crt ${KEY_DIR}
fi

cat ${BASE_CONFIG} \
    <(echo -e '<ca>') \
    ${KEY_DIR}/ca.crt \
    <(echo -e '</ca>\n<cert>') \
    ${KEY_DIR}/${1}.crt \
    <(echo -e '</cert>\n<key>') \
    ${KEY_DIR}/${1}.key \
    <(echo -e '</key>\n<tls-crypt>') \
    ${KEY_DIR}/ta.key \
    <(echo -e '</tls-crypt>') \
    > ${OUTPUT_DIR}/${1}.ovpn
