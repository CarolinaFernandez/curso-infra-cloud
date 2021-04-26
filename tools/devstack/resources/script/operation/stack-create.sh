#!/bin/bash

# Creates an OpenStack stack (Heat) from a template
# See https://docs.openstack.org/heat/queens/getting_started/create_a_stack.html

# openstack stack create -t http://git.openstack.org/cgit/openstack/heat-templates/plain/hot/F20/WordPress_Native.yaml --parameter key_name=cloudinfra-keypair --parameter image_id=Fedora-Cloud-Base-32-1.6.x86_64 --parameter instance_type=m1.small teststack

# Remove previous stack
openstack stack delete -y cirros-stack

# Create template and stack from it
cat <<EOF>>os-stack.yml
heat_template_version: 2018-08-31

description: Simple template to deploy a single compute instance

parameters:
  key_name:
    type: string
    label: Key Name
    description: Name of key-pair to be used for compute instance
    default: cloudinfra-keypair
  image_id:
    type: string
    label: Image ID
    description: Image to be used for compute instance
    default: cirros-0.3.5-x86_64-disk.img
  instance_type:
    type: string
    label: Instance Type
    description: Type of instance (flavor) to be used
    default: c1r1Gd5G
  network_name:
    type: string
    label: Network Name
    description: Name of network to be used
    default: private

resources:
  cirros-heat:
    type: OS::Nova::Server
    properties:
      key_name: { get_param: key_name }
      image: { get_param: image_id }
      flavor: { get_param: instance_type }
      networks:
        - network: { get_param: network_name }
EOF

openstack stack create -t os-stack.yml --parameter key_name=cloudinfra-keypair --parameter image_id=cirros-0.3.5-x86_64-disk.img --parameter instance_type=c1r1Gd5G --parameter network_name=privnet1 cirros-stack

# Clean up
rm -f os-stack.yml
