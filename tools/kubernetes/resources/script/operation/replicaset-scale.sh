#!/usr/bin/env bash

# Scale a given replicaset from the current number of replicas to the desired one

DEPLOYMENT_NAME=$1
CURRENT_REPLICAS=$2
DESIRED_REPLICAS=$3

[[ -z $DEPLOYMENT_NAME ]] && echo "Error: falta informacion: nombre del deployment" && exit 1
[[ -z $CURRENT_REPLICAS ]] && echo "Error: falta informacion: numero de replicas actuales" && exit 1
[[ -z $DESIRED_REPLICAS ]] && echo "Error: falta informacion: numero de replicas esperadas" && exit 1

kubectl scale --current-replicas=${CURRENT_REPLICAS} --replicas=${DESIRED_REPLICAS} deployment/${DEPLOYMENT_NAME}
