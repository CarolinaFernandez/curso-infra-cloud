#!/bin/bash

SECRET_NAME=$1

[[ -z $SECRET_NAME ]] && echo "Error: falta informacion: nombre o ID del secret" && exit 1

kubectl get secret ${SECRET_NAME} -o jsonpath="{.data.password}" | base64 --decode
