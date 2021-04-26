#!/bin/bash

IMG_ID=$1

[[ -z $IMG_ID ]] && echo "Error: falta informacion: ID o nombre de la imagen" && exit 1

openstack image show ${IMG_ID}
