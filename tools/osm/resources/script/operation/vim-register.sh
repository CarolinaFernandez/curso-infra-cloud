#!/bin/bash

VIM_NAME=$1
VIM_URL=$2
TENANT=$3
USER=$4
PASSWORD=$5

[[ -z $VIM_NAME ]] && echo "Error: falta informacion: nombre de la VIM" && exit 1
[[ -z $VIM_URL ]] && echo "Error: falta informacion: direccion de la VIM" && exit 1
[[ -z $TENANT ]] && echo "Error: falta informacion: proyecto" && exit 1
[[ -z $USER ]] && echo "Error: falta informacion: usuario" && exit 1
[[ -z $PASSWORD ]] && echo "Error: falta informacion: password" && exit 1

osm vim-create --name ${VIM_NAME} --user ${USER} --password ${PASSWORD} --auth_url ${VIM_URL} --tenant ${TENANT} --account_type openstack --config="{security_groups: default, keypair: cloudinfra-keypair}"
