#!/bin/bash

SECGROUP_ID=$1

[[ -z $SECGROUP_ID ]] && echo "Error: falta informacion: ID o nombre del security group" && exit 1

openstack security group show ${SECGROUP_ID}
openstack security group rule list ${SECGROUP_ID}
