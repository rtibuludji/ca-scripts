#!/bin/bash

#
# https://jamielinux.com/docs/openssl-certificate-authority/create-the-intermediate-pair.html
#
set -e

SOURCE_DIR="$(cd $(dirname "${BASH_SOURCE-$0}"); pwd)"
CA_HOME="$(cd ${SOURCE_DIR}/..; pwd)"

CA_NAME=$1
if [ -z ${CA_NAME+x} ]
then 
    echo -e "error input: CA NAME is not set"
    exit 1
fi

if [ -z ${CA_NAME} ] 
then 
    echo -e "error input: CA NAME is empty"
    exit 1
fi

if test -f ${CA_HOME}/${CA_NAME}/intermediate/certs/intermediate.cert.pem 
then 
    replace = "n"
    read -ep "Intermediate CA certification already exists. replace Y/n? " replace
    if [[ ${replace} == 'Y' ]]
    then
        rm -rf ${CA_HOME}/${CA_NAME}/intermediate/certs/intermediate.cert.pem
    else
        echo -e "Cancel."
        exit 0
    fi 
fi

echo -e "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
days=7300
read -ep "Intermediate CA validity days? " days

pushd ${CA_HOME}/${CA_NAME}
    echo "...Creating Intermediate CA certificate - you will be asked for few data related to CA intermediate"
    openssl req -config intermediate/openssl.cnf -new -sha256 \
        -key intermediate/private/intermediate.key.pem \
        -out intermediate/csr/intermediate.csr.pem

    echo "...Singing intermediate CA certificate by root CA - you will be asked for password for root CA private key ..."
    openssl ca -config root/openssl.cnf -extensions v3_intermediate_ca \
        -days 3650 -notext -md sha256 \
        -in intermediate/csr/intermediate.csr.pem \
        -out intermediate/certs/intermediate.cert.pem

    echo "... Setting permissions"
    chmod 444 intermediate/certs/intermediate.cert.pem

    echo "... Verifying certificate"
    openssl x509 -noout -text \
        -in intermediate/certs/intermediate.cert.pem
    openssl verify -CAfile root/certs/ca.cert.pem \
        intermediate/certs/intermediate.cert.pem
    
    echo "... Creating CA chain"
    cat root/certs/ca.cert.pem \
        intermediate/certs/intermediate.cert.pem > intermediate/certs/ca-chain.cert.pem
    
    echo "... Setting permissions"
    chmod 444 intermediate/certs/ca-chain.cert.pem    
popd
