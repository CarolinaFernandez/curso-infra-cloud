#!/bin/bash

SERVER_ID=$1

[[ -z $SERVER_ID ]] && echo "Error: falta informacion: ID o nombre de la VM" && exit 1

openstack server show ${SERVER_ID}
