#!/usr/bin/env bash

COMPOSE_NAME=$1

[[ -z $COMPOSE_NAME ]] && echo "Error: falta informacion: nombre del compose" && exit 1

if [[ -d ${COMPOSE_NAME} ]]; then
    current=$PWD
    cd ${COMPOSE_NAME}
    docker-compose ps
    cd ${current}
else
    echo "Compose \"${COMPOSE_NAME}\" does not exist"
fi
