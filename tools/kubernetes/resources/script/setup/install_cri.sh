#!/usr/bin/env bash

VERSION=$1
[[ -z $VERSION ]] && echo "Error: no version was defined" && exit 1

##
# Install and setup CRI-O
#

# See https://kubernetes.io/docs/setup/production-environment/container-runtimes/#cri-o

USER=vagrant

# Create the .conf file to load the modules at bootup
cat <<EOF | sudo tee /etc/modules-load.d/crio.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Set up required sysctl params, these persist across reboots.
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

## Apply cfg from the given file
sudo sysctl --system

## Add CRI-O repository
export OS=xUbuntu_20.04
export VERSION=${VERSION}
cat <<EOF | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /
EOF
cat <<EOF | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.list
deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/ /
EOF

curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/libcontainers.gpg add -
curl -L https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$VERSION/$OS/Release.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/libcontainers-cri-o.gpg add -

## Install CRI-O and the runc engine
sudo apt-get update
sudo apt-get install -y ca-certificates
sudo apt-get upgrade -y
sudo apt-get update
sudo apt-get install -y cri-o cri-o-runc

## Enable CRI-O
sudo systemctl daemon-reload
sudo systemctl enable crio --now
