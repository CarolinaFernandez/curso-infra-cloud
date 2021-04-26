#!/bin/bash

ROUTER_NAME=$1
SUBNET_NAME=$2

[[ -z $ROUTER_NAME ]] && echo "Error: falta informacion: nombre del router" && exit 1
[[ -z $SUBNET_NAME ]] && echo "Error: falta informacion: nombre de la subred" && exit 1

openstack router add subnet ${ROUTER_NAME} ${SUBNET_NAME}
