#!/usr/bin/env bash

IMAGE_NAME=$1
LABEL_NAME=$2

[[ -z $IMAGE_NAME ]] && echo "Error: falta informacion: nombre de la imagen" && exit 1
[[ -z $LABEL_NAME ]] && echo "Error: falta informacion: nombre del label" && exit 1

docker image rm ${IMAGE_NAME}:${LABEL_NAME}
