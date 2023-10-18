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

if test -f ${CA_HOME}/${CA_NAME}/intermediate/private/intermediate.key.pem 
then 
    replace = "n"
    read -ep "Intermidate CA private key already exists. replace Y/n? " replace
    if [[ ${replace} == "Y" ]]
    then
        rm -rf ${CA_HOME}/${CA_NAME}/intermediate/private/intermediate.key.pem
    else
        echo -e "Cancel."
        exit 0
    fi 
fi

echo -e "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
pushd ${CA_HOME}/${CA_NAME}/intermediate
    echo "... Creating Intermediate CA private key ca.key.pem - you will be asked for password for new key"
    openssl genrsa -aes256 -out private/intermediate.key.pem 4096

    echo "... Setting permissions"
    chmod 400 private/intermediate.key.pem
popd
echo -e "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
