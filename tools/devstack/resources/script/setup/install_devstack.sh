#!/usr/bin/env bash

# Updating requirements
sudo apt-get update
sudo apt-get install -y python3-pip python3-distutils

# Add user
sudo useradd -s /bin/bash -d /opt/stack -m stack
echo "stack ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/stack

# Place configuration
## (from vagrant's home to stack's home)
sudo cp ~/local.conf /opt/stack/

# Download DevStack
cd /opt
[[ -d devstack ]] && (cd devstack && ./unstack.sh && cd ..)
[[ -d devstack ]] && sudo rm -rf devstack

# https://docs.openstack.org/devstack/latest/
# Download code and select the expected branch
sudo export GIT_SSL_NO_VERIFY=1
sudo git config --global http.sslverify false
sudo git clone --branch stable/xena https://opendev.org/openstack/devstack

# Place configuration
## (from stack's home to /opt/devstack)
sudo cp ~/local.conf /opt/devstack/

sudo chown stack:stack devstack -R
sudo chown stack:stack stack -R

# Install
## https://stackoverflow.com/questions/32369328/changing-user-during-vagrant-provisioning
sudo runuser -l stack -c "export GIT_SSL_NO_VERIFY=1"
sudo -u stack git config --global http.sslverify false
sudo runuser -l stack -c "cd /opt/devstack && ./stack.sh"

# Persist loading of the OpenRC file
cat <<EOF>>~/.bashrc
# Load OpenStack OpenRC file (with admin permissions)
source /opt/devstack/openrc admin admin
EOF
