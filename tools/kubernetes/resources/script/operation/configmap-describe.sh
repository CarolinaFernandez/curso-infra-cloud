#!/usr/bin/env bash

CONFIGMAP_NAME=$1

[[ -z $CONFIGMAP_NAME ]] && echo "Error: falta informacion: nombre o ID del configmap" && exit 1

kubectl describe configmap ${CONFIGMAP_NAME}
