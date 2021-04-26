#!/bin/bash

PKG_NAME=$1
VIM_ID=$2

[[ -z $PKG_NAME ]] && echo "Error: falta informacion: nombre del servicio" && exit 1
[[ -z $VIM_ID ]] && echo "Error: falta informacion: ID o nombre de la VIM" && exit 1

rnd_str=$(tr -dc a-z0-9 </dev/urandom | head -c 5 ; echo '')
# Adjust name to filter out the ending indicators/types
PKG_NAME=${PKG_NAME//-ns/}
osm ns-create --ns_name ${PKG_NAME}_${rnd_str} --nsd_name ${PKG_NAME}-ns --vim_account ${VIM_ID}
