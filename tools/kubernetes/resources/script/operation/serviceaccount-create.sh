#!/usr/bin/env bash

# Create a serviceaccount and clusterrolebinding, both in a specific namespace

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: k8s-gui
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: gui-user
  namespace: k8s-gui
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: gui-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: gui-user
  namespace: k8s-gui
EOF
