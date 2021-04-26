#!/bin/bash

# Creates a VM with a given image, flavor, security network, keypair and connected to a specific port in a network

SERVER_NAME=$1
IMAGE_NAME=$2
FLAVOR_NAME=$3
SECGROUP_NAME=$4
KEY_NAME=$5
PORT_NAME=$6

[[ -z $SERVER_NAME ]] && echo "Error: falta informacion: nombre de la VM" && exit 1
[[ -z $IMAGE_NAME ]] && echo "Error: falta informacion: nombre de la imagen" && exit 1
[[ -z $FLAVOR_NAME ]] && echo "Error: falta informacion: nombre del flavor" && exit 1
[[ -z $SECGROUP_NAME ]] && echo "Error: falta informacion: nombre del security group" && exit 1
[[ -z $KEY_NAME ]] && echo "Error: falta informacion: nombre del par de claves" && exit 1
[[ -z $PORT_NAME ]] && echo "Error: falta informacion: nombre del puerto de red" && exit 1

openstack server create ${SERVER_NAME} --image ${IMAGE_NAME} --flavor ${FLAVOR_NAME} --security-group ${SECGROUP_NAME} --key-name ${KEY_NAME} --port=${PORT_NAME}
