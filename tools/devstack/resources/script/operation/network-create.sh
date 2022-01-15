#!/usr/bin/env bash

# Call like this: ./network-create.sh network-name 10.0.10.0 24

NET_NAME=$1
SUBNET_CIDR_NM=$2
SUBNET_MASK=$3

[[ -z $NET_NAME ]] && echo "Error: falta informacion: nombre de la red" && exit 1
[[ -z $SUBNET_CIDR_NM ]] && echo "Error: falta informacion: CIDR de la red (sin mascara)" && exit 1
[[ -z $SUBNET_MASK ]] && echo "Error: falta informacion: mascara de la red" && exit 1

SUBNET_POOL_START=${SUBNET_CIDR_NM%.*}

openstack network create ${NET_NAME}
openstack subnet create ${NET_NAME}-subnet --network ${NET_NAME} --subnet-range ${SUBNET_CIDR_NM}/${SUBNET_MASK} --gateway ${SUBNET_POOL_START}.1 --allocation-pool start=${SUBNET_POOL_START}.2,end=${SUBNET_POOL_START}.254
