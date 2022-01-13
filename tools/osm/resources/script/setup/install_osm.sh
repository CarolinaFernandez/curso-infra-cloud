#!/bin/bash

# Update and install dependencies
sudo apt-get update
sudo apt-get -y upgrade
#sudo apt install docker-ce=18.09
sudo apt install docker-ce=20.10

# Install ORMr10
##sudo kubeadm reset -f; ./install_osm.sh --uninstall; sudo apt remove -y --allow-change-held-packages --purge kube*; sudo rm -rf /etc/kubernetes/ /etc/cni /var/lib/etcd
sudo mkdir -p /opt/osm
sudo chown vagrant:vagrant /opt/osm -R
cd /opt/osm
##wget https://osm-download.etsi.org/ftp/osm-10.0-ten/install_osm.sh
##chmod +x install_osm.sh
##./install_osm.sh --k8s_monitor --elk_stack 2>&1 | tee osm_install_log.txt
#wget https://osm-download.etsi.org/ftp/osm-9.0-nine/install_osm.sh
#chmod +x install_osm.sh
##./install_osm.sh 2>&1 | tee osm_install_log.txt
##./install_osm.sh -c swarm 2>&1 | tee osm_install_log.txt
#./install_osm.sh --charmed 2>&1 | tee osm_install_log.txt

#sudo apt install -y zfsutils-linux
#sudo adduser $USER lxd
#newgrp lxd
#id
#lxc list
#lxd init
