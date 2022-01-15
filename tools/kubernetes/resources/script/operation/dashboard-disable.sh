#!/usr/bin/env bash

##
# Disable the Kubernetes Dashboard
#

# See: https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md

# Remove account and service role
kubectl -n kubernetes-dashboard delete serviceaccount admin-user
kubectl -n kubernetes-dashboard delete clusterrolebinding admin-user

# Remove the dashboard deployment
kubectl delete deployment -n kubernetes-dashboard --all

# Disable kubectl proxy
kubectl_proxy_pid=$(ps aux | grep "kubectl proxy" | grep -v "grep" | head -1 | awk -F ' ' '{print $2}')
kill -9 ${kubectl_proxy_pid}
