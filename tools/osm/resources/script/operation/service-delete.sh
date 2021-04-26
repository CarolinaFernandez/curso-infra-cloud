#!/bin/bash


SRV_ID=$1

[[ -z $SRV_ID ]] && echo "Error: falta informacion: nombre del servicio" && exit 1

osm ns-delete $SRV_ID
