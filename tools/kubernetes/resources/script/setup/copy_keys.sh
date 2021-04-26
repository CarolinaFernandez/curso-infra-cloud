#!/bin/bash

##
# Authorise previously copied SSH keys to allow remote access from other nodes in the cluster
#

USER=vagrant

# Authorise keys
sudo -u ${USER} mkdir -p /home/${USER}/.ssh
sudo -u ${USER} cat /home/${USER}/.ssh/cloudinfra.pub >> /home/${USER}/.ssh/authorized_keys

# Update permissions
sudo -u ${USER} chmod 600 /home/${USER}/.ssh/cloudinfra
sudo -u ${USER} chmod 664 /home/${USER}/.ssh/cloudinfra.pub
