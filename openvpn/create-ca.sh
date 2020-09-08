#!/bin/bash
# Setting up CA server

EASYRSA_DIR=/root/certificates

mkdir -p $EASYRSA_DIR && cd $EASYRSA_DIR

####################
# For ubuntu 20.04 #
####################
if [ -z "$(dpkg -l |grep easy-rsa)" ]; then
    apt update && apt install -y easy-rsa && rm -rf /var/lib/apt/lists/*
fi

ln -s /usr/share/easy-rsa/* $EASYRSA_DIR
####################

####################
# For ubuntu 18.04 #
####################
#wget https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.7/EasyRSA-3.0.7.tgz

#tar -xf EasyRSA-3.0.7.tgz && \
#mv ~/easy-rsa/EasyRSA-3.0.7/* . && \
#rm -r ~/easy-rsa/EasyRSA-3.0.7 ~/easy-rsa/EasyRSA-3.0.7.tgz
####################

cd $EASYRSA_DIR

./easyrsa init-pki

echo "set_var EASYRSA_REQ_CN    \"ORCHESTRA CA\"
set_var EASYRSA_REQ_COUNTRY    \"BE\"
set_var EASYRSA_REQ_PROVINCE   \"Antwerpen\"
set_var EASYRSA_REQ_CITY       \"Antwerpen\"
set_var EASYRSA_REQ_ORG        \"HAI-SCS\"
set_var EASYRSA_REQ_EMAIL      \"joao.jfnp@gmail.com\"
set_var EASYRSA_REQ_OU         \"HAI-SCS\"
set_var EASYRSA_ALGO           \"ec\"
set_var EASYRSA_DIGEST         \"sha512\"" > vars

./easyrsa --batch build-ca nopass


