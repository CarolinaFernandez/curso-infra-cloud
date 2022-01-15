#!/usr/bin/env bash

ROUTER_ID=$1

[[ -z $ROUTER_ID ]] && echo "Error: falta informacion: ID o nombre del router" && exit 1

openstack router show ${ROUTER_ID}
