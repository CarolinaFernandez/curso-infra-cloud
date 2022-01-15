#!/usr/bin/env bash

# Create a horizonalpodautoscaler to act on a given replicaset

REPLICASET_NAME=$1
MINIMUM_REPLICAS=$2
MAXIMUM_REPLICAS=$3
CPU_PERCENT=$4

[[ -z $REPLICASET_NAME ]] && echo "Error: falta informacion: nombre del replicaset" && exit 1
[[ -z $MINIMUM_REPLICAS ]] && echo "Error: falta informacion: numero de replicas minimas" && exit 1
[[ -z $MAXIMUM_REPLICAS ]] && echo "Error: falta informacion: numero de replicas maximas" && exit 1
[[ -z $CPU_PERCENT ]] && echo "Error: falta informacion: porcentaje de CPU objetivo" && exit 1

kubectl autoscale rs/${REPLICASET_NAME} --max=${MAXIMUM_REPLICAS} --min=${MINIMUM_REPLICAS} --cpu-percent=${CPU_PERCENT}
