#!/usr/bin/env bash

##
# Install and setup Docker
#

# Global variables (apt-cache madison ${package})
DOCKER_VERSION="5:20.10.12~3-0~ubuntu-focal"

## Update apt package index
sudo apt-get update
sudo apt-get -y upgrade

# Install Docker

## Install more requirements for Docker
sudo apt-get install -y gnupg lsb-release

## Setup Docker public signing key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

## Setup stable repository
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

## Update apt package index, install docker engine
sudo apt-get update
sudo apt-get install -y docker-ce="${DOCKER_VERSION}" docker-ce-cli="${DOCKER_VERSION}" containerd.io

## Add user to docker group
sudo groupadd docker || true
sudo usermod -aG docker $USER && newgrp docker
