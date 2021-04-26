#!/bin/bash

SECRET_NAME=$1

[[ -z $SECRET_NAME ]] && echo "Error: falta informacion: nombre o ID del secret" && exit 1

kubectl describe secret ${SECRET_NAME}
