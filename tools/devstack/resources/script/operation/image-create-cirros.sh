#!/usr/bin/env bash

wget http://download.cirros-cloud.net/0.3.5/cirros-0.3.5-x86_64-disk.img
openstack image create --file="cirros-0.3.5-x86_64-disk.img" --container-format=bare --disk-format="qcow2" cirros-0.3.5-x86_64-disk.img
rm -f cirros-0.3.5-x86_64-disk.img
