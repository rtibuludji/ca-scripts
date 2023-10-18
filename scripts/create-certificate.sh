#!/bin/bash

#
# @author is. Redi Tibuludji
#

# use to exit when the command exits with a non-zero status.
set -e

SOURCE_DIR="$(cd $(dirname "${BASH_SOURCE-$0}"); pwd)"
CA_HOME="$(cd ${SOURCE_DIR}/..; pwd)"

CA_NAME=$1
CERT_NAME=$2
CERT_TYPE=$3

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

if [ -z ${CERT_NAME+x} ]
then 
    echo -e "error input: CERT NAME is not set"
    exit 1
fi

if [ -z ${CERT_NAME} ] 
then 
    echo -e "error input: CERT NAME is empty"
    exit 1
fi

if [ -z ${CERT_TYPE} ] 
then 
    CERT_TYPE=server_cert
fi

echo -e "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
days=375
read -ep "Cert validity days? " days

pushd ${CA_HOME}/${CA_NAME}

    if [ ! -f "intermediate/private/${CERT_NAME}.key.pem" ]
    then
        echo -e "... Creating private key - you will be asked to provide password for new key"
        openssl genrsa -aes256 \
            -out "intermediate/private/${CERT_NAME}.key.pem" 2048
        echo -e ".. Setting permissions"
        chmod 400 "intermediate/private/${CERT_NAME}.key.pem"
    fi

    if [ ! -f "intermediate/csr/${CERT_NAME}.csr.pem" ]; then
        echo -e ".. Generating certificate signing request - you will be asked for few data related to certificate"
        openssl req -config "intermediate/openssl.cnf" \
            -key "intermediate/private/${CERT_NAME}.key.pem" \
            -new -sha256 -out "intermediate/csr/${CERT_NAME}.csr.pem"
    fi

    if [ ! -f "intermediate/certs/${CERT_NAME}.cert.pem" ]; then
        echo -e "Singing CSR by intermediate CA - you will be asked for password to intermediate CA private key"
        openssl ca -config "intermediate/openssl.cnf" \
            -extensions ${CERT_TYPE} -days ${days} -notext -md sha256 \
            -in "intermediate/csr/${CERT_NAME}.csr.pem" \
            -out "intermediate/certs/${CERT_NAME}.cert.pem"
        echo -e "Setting permissions..."
        chmod 444 "intermediate/certs/${CERT_NAME}.cert.pem"
    fi

    echo -e "... Verifying certificate..."
    openssl x509 -noout -text \
        -in "intermediate/certs/${CERT_NAME}.cert.pem"
    openssl verify -CAfile "intermediate/certs/ca-chain.cert.pem" \
        "intermediate/certs/${CERT_NAME}.cert.pem"

popd 

echo -e "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
