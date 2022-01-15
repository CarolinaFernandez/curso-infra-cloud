#!/usr/bin/env bash

wget https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-disk1.img
openstack image create --file="xenial-server-cloudimg-amd64-disk1.img" --container-format=bare --disk-format="qcow2" ubuntu16.04
rm -f xenial-server-cloudimg-amd64-disk1.img
