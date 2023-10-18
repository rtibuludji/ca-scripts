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

echo -e "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
pushd ${CA_HOME}/${CA_NAME}

    if [ ! -f "intermediate/certs/${CERT_NAME}.tar" ]; then
        if [ -f "intermediate/certs/${CERT_NAME}.cert.pem" ] && [ -f "intermediate/private/${CERT_NAME}.key.pem" ]; then
            echo "Creating ${CA_HOME}/${CA_NAME}/intermediate/certs/${CERT_NAME}.tar with private key and certificates: ${CERT_NAME} and CA chain..."
            tar cf "intermediate/certs/${CERT_NAME}.tar" "intermediate/certs/${CERT_NAME}.cert.pem" "intermediate/private/${CERT_NAME}.key.pem" "intermediate/certs/ca-chain.cert.pem"
        else
            echo "Not exported..."
        fi
    else
        echo "Exported to ${CERT_NAME}.tar"
    fi
popd
echo -e "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
