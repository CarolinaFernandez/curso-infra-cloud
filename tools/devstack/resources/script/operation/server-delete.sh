#!/usr/bin/env bash

# Removes a VM with a given image

SERVER_NAME=$1

[[ -z $SERVER_NAME ]] && echo "Error: falta informacion: nombre o ID de la VM" && exit 1

openstack server delete ${SERVER_NAME}
