#
# Slightly adapted from https://github.com/kodekloudhub/certified-kubernetes-administrator-course
# File: https://github.com/kodekloudhub/certified-kubernetes-administrator-course/blob/master/ubuntu/vagrant/setup-hosts.sh
#

#!/bin/bash
set -e
IFNAME=$1
ADDRESS="$(ip -4 addr show $IFNAME | grep "inet" | head -1 |awk '{print $2}' | cut -d/ -f1)"
sed -e "s/^.*${HOSTNAME}.*/${ADDRESS} ${HOSTNAME} ${HOSTNAME}.local/" -i /etc/hosts

# remove ubuntu-focal entry
sed -e '/^.*ubuntu-focal.*/d' -i /etc/hosts

# Update /etc/hosts about other hosts
cat >> /etc/hosts <<EOF
192.168.33.110  cloudinfra-k8s-master
192.168.33.120  cloudinfra-k8s-node01
192.168.33.130  cloudinfra-k8s-node02
EOF
