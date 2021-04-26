#!/bin/bash

PORT_ID=$1

[[ -z $PORT_ID ]] && echo "Error: falta informacion: ID del puerto" && exit 1

openstack port show ${PORT_ID}
