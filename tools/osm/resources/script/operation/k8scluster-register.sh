#!/usr/bin/env bash

osm vim-create --name dummy_vim --user u --password p --tenant p --account_type dummy --auth_url http://localhost/dummy

osm k8scluster-add k8s-cluster --creds ~/.kube/config --vim dummy_vim --k8s-nets '{k8s_net1: null}' --version "1.15.12" --description="Internal k8s cluster"
