#!/bin/bash

HOST_IP=$1
[[ -z $HOST_IP ]] && echo "Error: no host IP was defined" && exit 1

##
# Setup kubeworker nodes
#

USER=vagrant
KUBEADMJOIN_FILE=kubeadmjoin

# Join the cluster
sudo -u ${USER} ping -c 1 ${HOST_IP}
sudo -u ${USER} scp -oStrictHostKeyChecking=no -i /home/${USER}/.ssh/cloudinfra ${USER}@${HOST_IP}:/home/${USER}/${KUBEADMJOIN_FILE} /home/${USER}/ || true
sudo -u ${USER} mkdir /home/${USER}/.kube
sudo -u ${USER} scp -oStrictHostKeyChecking=no -i /home/${USER}/.ssh/cloudinfra ${USER}@${HOST_IP}:/home/${USER}/.kube/config /home/${USER}/.kube/ || true
sudo -u ${USER} cat /home/${USER}/${KUBEADMJOIN_FILE} || true
echo "Joining cluster from host with IP=${HOST_IP}"
sudo -u ${USER} sudo /home/${USER}/${KUBEADMJOIN_FILE} || true
