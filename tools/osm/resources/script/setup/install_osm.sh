#!/bin/bash

# Update and install dependencies
sudo apt-get update
sudo apt-get -y upgrade
sudo apt install docker-ce=18.09

# Install ORMr9
sudo mkdir -p /opt/osm
sudo chown vagrant:vagrant /opt/osm -R
cd /opt/osm
wget https://osm-download.etsi.org/ftp/osm-9.0-nine/install_osm.sh
chmod +x install_osm.sh
./install_osm.sh --k8s_monitor --elk_stack 2>&1 | tee osm_install_log.txt
