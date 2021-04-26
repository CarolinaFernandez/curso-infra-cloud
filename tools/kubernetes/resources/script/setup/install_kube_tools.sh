#!/bin/bash

##
# Install Kubernetes-related tools
#

# See https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

USER=vagrant

# GPG key
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Setup tools
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl

# Allow autocomplete for kubectl
# See: https://kubernetes.io/docs/reference/kubectl/cheatsheet/

sudo apt-get install -y bash-completion
# Setup autocomplete in bash into the current shell, bash-completion package should be installed first
#sudo -u ${USER} source <(kubectl completion bash)
# Add autocomplete permanently to your bash shell
sudo -u ${USER} echo "source <(kubectl completion bash)" >> ~/.bashrc

sudo apt-mark hold kubelet kubeadm kubectl
