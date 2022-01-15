#!/usr/bin/env bash

# Create an generic secret
kubectl create secret generic opaque-secret --from-literal=password=accesspassword
