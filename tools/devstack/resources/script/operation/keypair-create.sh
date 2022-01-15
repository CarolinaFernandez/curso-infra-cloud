#!/usr/bin/env bash

# Create keypair
ssh-keygen -t rsa -f ~/.ssh/id_openstack -q -N ""
# Convert from OpenSSH to RSA
ssh-keygen -p -N "" -m pem -f ~/.ssh/id_openstack

# Register keypair
openstack keypair create cloudinfra-keypair --private-key ~/.ssh/id_openstack
