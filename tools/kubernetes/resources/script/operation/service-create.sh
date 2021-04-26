#!/bin/bash

# Create a deployment, then a service
# and expose it through a Node port

# Slightly adapted from https://stackoverflow.com/questions/49511427/access-local-kubernetes-cluster-running-in-virtualbox

cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 2
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: echoserver
          image: gcr.io/google_containers/echoserver:1.9
---

apiVersion: v1
kind: Service
metadata:
  name: nginx-service-np
  labels:
    name: nginx-service-np
spec:
  type: NodePort
  ports:
    - port: 8082        # Cluster IP - example: http://10.109.199.234:8082
      targetPort: 8080  # Application port
      nodePort: 30000   # External IP (VirtualBox) - example: http://192.168.33.120:30000, http://192.168.33.130:30000
      protocol: TCP
      name: http
  selector:
    app: nginx
EOF
