#!/bin/bash

# Create a deployment, then a service
# and expose it through an Ingress controller

# Slightly adapted from https://gist.github.com/chukaofili/d0a6713734d0953ce1ce667958464edb

cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: echoserver-ing
spec:
  replicas: 2
  selector:
    matchLabels:
      app: echoserver-ing
  template:
    metadata:
      labels:
        app: echoserver-ing
    spec:
      containers:
      - image: gcr.io/google_containers/echoserver:1.9
        imagePullPolicy: Always
        name: echoserver-ing
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: echoserver-ing
spec:
  ports:
  - port: 80
    targetPort: 8080
    protocol: TCP
  selector:
    app: echoserver-ing
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: echoserver-ing
  annotations:
    kubernetes.io/ingress.class: "nginx"
spec:
  rules:
  - host: echo.cloudinfra.local
    http:
      paths:
      - path: /
        backend:
          serviceName: echoserver-ing
          #servicePort: 80
          servicePort: 30000
EOF

# FIXME
echo "Service accessible at http://192.178.33.120:30000, http://192.178.33.130:30000"
# http://127.0.0.1:30010/api/v1/namespaces/default/pods
