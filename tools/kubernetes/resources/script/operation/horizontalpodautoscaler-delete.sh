#!/usr/bin/env bash

HPA_NAME=$1

[[ -z $HPA_NAME ]] && echo "Error: falta informacion: nombre o ID del horizontalpodautoscaler" && exit 1

kubectl delete hpa ${HPA_NAME}
