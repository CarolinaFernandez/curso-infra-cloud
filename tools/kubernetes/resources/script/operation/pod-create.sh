#!/usr/bin/env bash

# Create a pod using the nginx image over a Debian OS
# and including a custom entry page

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: share-pod
  labels:
    app: share-pod
spec:
  volumes:
  - name: host-volume
    hostPath:
      path: /home/docker/pod-volume
  containers:
  - image: nginx
    name: nginx
    ports:
      - containerPort: 80
    volumeMounts:
    - mountPath: /usr/share/nginx/html
      name: host-volume
  - image: debian
    name: debian
    volumeMounts:
    - mountPath: /host-vol
      name: host-volume
    command: ["/bin/sh", "-c", "echo Introduction to Kubernetes > /host-vol/index.html; sleep 3600"]
EOF
