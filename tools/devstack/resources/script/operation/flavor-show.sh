#!/bin/bash

FLV_ID=$1

[[ -z $FLV_ID ]] && echo "Error: falta informacion: ID o nombre del flavor" && exit 1

openstack flavor show ${FLV_ID}
