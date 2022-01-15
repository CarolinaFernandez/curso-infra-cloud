#!/usr/bin/env bash

PORT_NAME=$1
NETWORK_ID=$2
SUBNETWORK_ID=$3
IP_ADDR=$4

[[ -z $PORT_NAME ]] && echo "Error: falta informacion: nombre del puerto" && exit 1
[[ -z $NETWORK_ID ]] && echo "Error: falta informacion: ID de la red" && exit 1
[[ -z $SUBNETWORK_ID ]] && echo "Error: falta informacion: ID de la subred" && exit 1
[[ -z $IP_ADDR ]] && echo "Error: falta informacion: direccion IP" && exit 1

openstack port create ${PORT_NAME} --network ${NETWORK_ID} --fixed-ip subnet=${SUBNETWORK_ID},ip-address=${IP_ADDR}
