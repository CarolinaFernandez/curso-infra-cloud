#!/usr/bin/env bash

K8C_ID=$1

[[ -z $K8C_ID ]] && echo "Error: falta informacion: ID o nombre del cluster de Kubernetes" && exit 1

osm k8scluster-show $K8C_ID
