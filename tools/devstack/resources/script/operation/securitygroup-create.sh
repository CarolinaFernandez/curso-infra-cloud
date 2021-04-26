#!/bin/bash

openstack security group create cloudinfra-sec

# Enable SSH traffic to hosts (set in default security group)
openstack security group rule create --proto icmp --dst-port 0 cloudinfra-sec
openstack security group rule create --proto tcp --dst-port 22 cloudinfra-sec
