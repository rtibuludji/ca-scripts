#!/bin/bash

#
# @author is. Redi Tibuludji
#
# installation scripts to destination installation directory ${CA_HOME} 
#

# use to exit when the command exits with a non-zero status.
set -e


SOURCE_DIR="$(cd $(dirname "${BASH_SOURCE-$0}"); pwd)"

read -ep "please enter the directory for install the CA: " CA_HOME
if [ -z ${CA_HOME+x} ]
then 
    echo -e "error input: destination directory is not set"
    exit 1
fi

if [ -z ${CA_HOME} ] 
then 
    echo -e "error input: destination directory is empty"
    exit 1
fi

if [ -d ${CA_HOME} ] 
then
    CLEAN="n"
    read -ep "directory "${CA_HOME}" is exists. continue with clean/remove the directory (Y/n)? " CLEAN
    if [[ ${CLEAN} == "Y" ]] 
    then 
        rm -rf ${CA_HOME}
        mkdir ${CA_HOME}
        mkdir ${CA_HOME}/scripts
        mkdir ${CA_HOME}/conf
    fi 
else
    mkdir ${CA_HOME}
    mkdir ${CA_HOME}/scripts
    mkdir ${CA_HOME}/conf
fi

cp ${SOURCE_DIR}/templates/openssl-ca-root.cnf ${CA_HOME}/conf/openssl-ca-root-template.cnf
cp ${SOURCE_DIR}/templates/openssl-ca-intermediate.cnf ${CA_HOME}/conf/openssl-ca-intermediate-template.cnf

cp ${SOURCE_DIR}/scripts/setup-ca.sh ${CA_HOME}/scripts/setup-ca.sh
cp ${SOURCE_DIR}/scripts/create-ca-root-key.sh ${CA_HOME}/scripts/create-ca-root-key.sh
cp ${SOURCE_DIR}/scripts/create-ca-root-cert.sh ${CA_HOME}/scripts/create-ca-root-cert.sh
cp ${SOURCE_DIR}/scripts/create-ca-intermediate-key.sh  ${CA_HOME}/scripts/create-ca-intermediate-key.sh
cp ${SOURCE_DIR}/scripts/create-ca-intermediate-cert.sh  ${CA_HOME}/scripts/create-ca-intermediate-cert.sh

cp ${SOURCE_DIR}/scripts/create-certificate.sh ${CA_HOME}/scripts/create-certificate.sh
cp ${SOURCE_DIR}/scripts/export-certificate.sh ${CA_HOME}/scripts/export-certificate.sh

chmod +x ${CA_HOME}/scripts/setup-ca.sh
chmod +x ${CA_HOME}/scripts/create-ca-root-key.sh
chmod +x ${CA_HOME}/scripts/create-ca-root-cert.sh
chmod +x ${CA_HOME}/scripts/create-ca-intermediate-key.sh
chmod +x ${CA_HOME}/scripts/create-ca-intermediate-cert.sh

chmod +x ${CA_HOME}/scripts/create-certificate.sh
chmod +x ${CA_HOME}/scripts/export-certificate.sh

DEFAULT="n"
read -ep "Do you want install default CA manager (Y/n)? " DEFAULT
if [[ ${DEFAULT} == "Y" ]]
then 
    ${CA_HOME}/scripts/setup-ca.sh default
fi
