#!/bin/bash

STACK_ID=$1

[[ -z $STACK_ID ]] && echo "Error: falta informacion: ID o nombre del stack" && exit 1

openstack stack delete -y ${STACK_ID}
