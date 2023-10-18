#!/bin/bash

#
# @author is. Redi Tibuludji
#

# use to exit when the command exits with a non-zero status.
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

if [ -d ${CA_HOME}/${CA_NAME} ]
then
    DELETE='n'
    read -ep "CA ["${CA_NAME}"] already define, delete all the contents (Y/n)? " DELETE
    if [[ ${DELETE} == 'Y' ]] 
    then
        rm -rf ${CA_HOME}/${CA_NAME}
    else 
        echo -e "Setup Cancel..."
        exit 0
    fi
fi

mkdir ${CA_HOME}/${CA_NAME}

echo -e "Setup CA ["${CA_NAME}"] root ..."
    mkdir ${CA_HOME}/${CA_NAME}/root  

    pushd ${CA_HOME}/${CA_NAME}/root 
        echo "... Creating root directories"
        mkdir certs crl newcerts private

        echo "... Setting permission"
        chmod 700 private

        echo "... Creating index file"
        touch index.txt

        echo "... Creating serial file"
        echo 1000 > serial 

        echo '... Copying OpenSSL configuration'
        cp $CA_HOME/conf/openssl-ca-root-template.cnf openssl.cnf
        sed -i 's#CA_HOME/root#'${CA_HOME}/${CA_NAME}/root'#g' openssl.cnf
    popd 

    ${CA_HOME}/scripts/create-ca-root-key.sh ${CA_NAME}
    ${CA_HOME}/scripts/create-ca-root-cert.sh ${CA_NAME}


echo -e "Setup CA ["${CA_NAME}"] intermediate ..."
    mkdir ${CA_HOME}/${CA_NAME}/intermediate

    pushd ${CA_HOME}/${CA_NAME}/intermediate 
        echo '... Creating intermediate directories'
        mkdir certs crl csr newcerts private

        echo '... Setting permission'
        chmod 700 private

        echo '... Creating index file'
        touch index.txt

        echo '... Creating serial file'
        echo 1000 > serial 

        echo '... Creating crlnumber file'
        echo 1000 > crlnumber

        echo '... Copying OpenSSL configuration'
        cp $CA_HOME/conf/openssl-ca-intermediate-template.cnf openssl.cnf
        sed -i 's#CA_HOME/intermediate#'${CA_HOME}/${CA_NAME}'/intermediate#g' openssl.cnf
    popd

    ${CA_HOME}/scripts/create-ca-intermediate-key.sh ${CA_NAME}
    ${CA_HOME}/scripts/create-ca-intermediate-cert.sh ${CA_NAME}
