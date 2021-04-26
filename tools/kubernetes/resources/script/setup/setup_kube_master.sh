#!/bin/bash

HOST_IP=$1
[[ -z $HOST_IP ]] && echo "Error: no host IP was defined" && exit 1

##
# Setup kubeadmin nodes
#

USER=vagrant
KUBEADMJOIN_FILE=kubeadmjoin

# Initialise the cluster
# See: https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/configure-cgroup-driver/

sudo -u ${USER} sudo kubeadm init --pod-network-cidr 10.244.0.0/16 --apiserver-advertise-address=${HOST_IP} > /home/${USER}/${KUBEADMJOIN_FILE}.bak 2>&1

# Setup the admission controllers (does not seem required for this version)
# See: https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/#how-do-i-turn-on-an-admission-controller
#sudo -u ${USER} sudo kube-apiserver --enable-admission-plugins=ResourceQuota

sudo cat /home/${USER}/${KUBEADMJOIN_FILE}.bak
sudo -u ${USER} sudo cat /home/${USER}/${KUBEADMJOIN_FILE}.bak | tail -2 > /home/${USER}/${KUBEADMJOIN_FILE}
sudo rm -f /home/${USER}/${KUBEADMJOIN_FILE}.bak
sudo -u ${USER} sudo chown ${USER}:${USER} /home/${USER}/${KUBEADMJOIN_FILE}
sudo -u ${USER} sudo chmod +x /home/${USER}/${KUBEADMJOIN_FILE}

# Configure the cluster
sudo -u ${USER} mkdir -p /home/${USER}/.kube
sudo -u ${USER} sudo cp -f /etc/kubernetes/admin.conf /home/${USER}/.kube/config
sudo -u ${USER} sudo chown ${USER}:${USER} /home/${USER}/.kube -R

sleep 5

# Setup the CNI
## Flannel
sudo -u ${USER} kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
## WeaveNet
#sudo -u ${USER} kubectl apply -f https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')

# Allow pod scheduling in the control plane
# See: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
sudo -u ${USER} kubectl taint nodes --all node-role.kubernetes.io/master-
