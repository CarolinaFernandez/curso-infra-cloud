#!/bin/bash

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: List
items:
- apiVersion: v1
  kind: ResourceQuota
  metadata:
    name: pods-low
  spec:
    hard:
      cpu: "1"
      memory: 1Gi
      pods: "3"
    scopeSelector:
      matchExpressions:
      - operator : In
        scopeName: PriorityClass
        values: ["low"]
---
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: low-prio
value: 1000000
globalDefault: false
description: "This priority class should be used for low priority pods only."
---
apiVersion: v1
kind: Pod
metadata:
  name: low-priority-1
spec:
  containers:
  - name: low-priority-1
    image: ubuntu
    command: ["/bin/sh"]
    args: ["-c", "while true; do echo hello; sleep 10;done"]
    resources:
      requests:
        memory: "2Gi"
        cpu: "500m"
      limits:
        memory: "2Gi"
        cpu: "500m"
  priorityClassName: low-prio
---
apiVersion: v1
kind: Pod
metadata:
  name: low-priority-2
spec:
  containers:
  - name: low-priority-2
    image: ubuntu
    command: ["/bin/sh"]
    args: ["-c", "while true; do echo hello; sleep 10;done"]
    resources:
      requests:
        memory: "1Gi"
        cpu: "500m"
      limits:
        memory: "2Gi"
        cpu: "500m"
  priorityClassName: low-prio
EOF
