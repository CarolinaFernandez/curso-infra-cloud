#!/bin/bash

CRONJOB_NAME=$1

[[ -z $CRONJOB_NAME ]] && echo "Error: falta informacion: nombre o ID del cronjob" && exit 1

kubectl describe cronjob ${CRONJOB_NAME}
