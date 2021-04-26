#!/bin/bash


VIM_ID=$1

[[ -z $VIM_ID ]] && echo "Error: falta informacion: ID o nombre de la VIM" && exit 1

osm vim-show $VIM_ID
