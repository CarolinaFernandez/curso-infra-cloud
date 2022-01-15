#!/usr/bin/env bash

# Delete the serviceaccount previously created and its associated resources

kubectl delete -n k8s-gui serviceaccount/gui-user
kubectl delete clusterrolebinding.rbac.authorization.k8s.io/gui-user
kubectl delete namespace/k8s-gui
