#!/bin/bash

# Create a configmap with some initial key
# note: this should *not* be done (mixing imperative/create with apply)
# and thus the next warning
kubectl create configmap redis-configmap --from-literal=player_initial_lives="3"

# Update configmap with more keys
# Then, create a pod (Redis instance) to be lnked to this configmap
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: redis-configmap
data:
  # property-like keys; each key maps to a simple value
  ui_properties_file_name: "user-interface.properties"

  # file-like keys
  game.properties: |
    enemy.types=aliens,monsters
    player.maximum-lives=5    
  user-interface.properties: |
    color.good=purple
    color.bad=yellow
    allow.textmode=true 
---
apiVersion: v1
kind: Pod
metadata:
  name: redis-pod
spec:
  containers:
  - name: redis-pod
    image: redis
    volumeMounts:
    - name: foo
      mountPath: "/etc/foo"
      readOnly: true
  volumes:
  - name: foo
    configMap:
      name: redis-configmap
EOF

