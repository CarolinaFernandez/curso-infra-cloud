#!/usr/bin/env bash

CONTAINER_NAME=$1

[[ -z $CONTAINER_NAME ]] && echo "Error: falta informacion: nombre del contenedor" && exit 1

docker rm -f ${CONTAINER_NAME}
