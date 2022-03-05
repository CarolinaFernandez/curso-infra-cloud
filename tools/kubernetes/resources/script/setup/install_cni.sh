#!/usr/bin/env bash

HOST_IP=$1
[[ -z $HOST_IP ]] && echo "Error: no host IP was defined" && exit 1
POD_CIDR=$2
[[ -z $POD_CIDR ]] && echo "Error: no pod CIDR was defined" && exit 1

###
## Install CNI
##
#

USER=vagrant

# Download and apply the Calico CNI
## Note: there can be only one pod network per cluster (the CNI-Genie project is trying to change this)
wget https://docs.projectcalico.org/manifests/calico.yaml

# Update the content with the value for CALICO_IPV4POOL_CIDR ("same as the one given in the kubeadm-config-crio.yaml beforehand")
cp -p calico.yaml calico-cni.yaml
sed -i "s|# - name: CALICO_IPV4POOL_CIDR|- name: CALICO_IPV4POOL_CIDR|g" calico-cni.yaml
# Important to apply correct indentation through spaces
# https://docs.projectcalico.org/reference/node/configuration#ip-autodetection-methods

#sed -i "s|#   value: \"192.168.0.0/16\"|  value: \"${POD_CIDR}\"|g" calico-cni.yaml
sed -i "s|#   value: \"192.168.0.0/16\"|  value: \"${POD_CIDR}\"\n            # Extra: adding to avoid auto-detection issues with IPs in VB\n            - name: IP_AUTODETECTION_METHOD\n              value: \"can-reach=${HOST_IP}\"|g" calico-cni.yaml

sudo -u ${USER} kubectl apply -f calico-cni.yaml
sleep 10

# Flannel
#sudo -u ${USER} kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
# WeaveNet
#sudo -u ${USER} kubectl apply -f https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')
