#!/usr/bin/env bash

##
# Setup any Kubernetes cluster node
#

# See https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

# Letting IPtables see bridged traffic
sudo modprobe br_netfilter

sudo cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

sudo cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

echo "net.bridge.bridge-nf-call-iptables=1" >> /etc/sysctl.d/10-bridge-nf-call-iptables.conf
# Apply cfg from the given file
sudo sysctl -p

sudo sysctl --system || true
