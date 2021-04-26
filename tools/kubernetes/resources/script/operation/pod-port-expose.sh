#!/bin/bash

# Create a service that exposes a port on an already existing pod

kubectl expose pod share-pod --type=NodePort --port=80
