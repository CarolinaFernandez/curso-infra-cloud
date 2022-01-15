#!/usr/bin/env bash

###
## Configure taints in specific nodes
##
#

USER=vagrant
CP_NODE=cp

## Allow pod scheduling in the control plane
## See: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
tainted_master_node=$(sudo -u ${USER} kubectl describe node ${CP_NODE} | grep Taints | cut -d ":" -f2 | tr -s " ")
tainted_master_node_extra=$(sudo -u ${USER} kubectl describe node ${CP_NODE} | grep Taints | cut -d ":" -f3 | tr -s " ")

if [[ ! -z "${tainted_master_node}:${tainted_master_node_extra}" ]]; then
    #sudo -u ${USER} kubectl taint nodes --all ${tainted_master_node}:${tainted_master_node_extra}-
    sudo -u ${USER} kubectl taint nodes ${CP_NODE} ${tainted_master_node}:${tainted_master_node_extra}-
fi
