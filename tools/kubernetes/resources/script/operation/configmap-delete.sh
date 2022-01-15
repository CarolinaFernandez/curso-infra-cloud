#!/usr/bin/env bash

# Delete a configmap previously created and its associated resources
kubectl delete configmap redis-configmap
kubectl delete pod redis-pod
