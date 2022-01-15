#!/usr/bin/env bash

LABEL_NAME=$1

[[ -z $LABEL_NAME ]] && echo "Error: falta informacion: label para el pod" && exit 1

kubectl get pods -l ${LABEL_NAME}
