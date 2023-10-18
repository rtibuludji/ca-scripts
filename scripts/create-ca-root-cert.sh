#!/bin/bash

#
# https://jamielinux.com/docs/openssl-certificate-authority/create-the-root-pair.html
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

if test -f ${CA_HOME}/${CA_NAME}/root/certs/ca.cert.pem 
then 
    replace = "n"
    read -ep "Root CA certificate already exists. replace Y/n? " replace
    if [[ ${replace} == "Y" ]]
    then
        rm -rf ${CA_HOME}/${CA_NAME}/root/certs/ca.cert.pem
    else
        echo -e "Cancel."
        exit 0
    fi 
fi

echo -e "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
days=7300
read -ep "Root CA validity days? " days

pushd ${CA_HOME}/${CA_NAME}/root
    echo "... Creating root CA certificate - you will be asked for few data related to CA"
    openssl req -config openssl.cnf \
        -key private/ca.key.pem \
        -new -x509 -days ${days} -sha256 -extensions v3_ca \
        -out certs/ca.cert.pem

    echo '... Setting permissions'
    chmod 444 certs/ca.cert.pem

    echo "... Verifying certificate"
    openssl x509 -noout -text -in certs/ca.cert.pem
popd
echo -e "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
