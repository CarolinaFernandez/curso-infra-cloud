#!/usr/bin/env bash

ROUTER_NAME=$1

[[ -z $ROUTER_NAME ]] && echo "Error: falta informacion: nombre del router" && exit 1

openstack router create ${ROUTER_NAME}
