#!/usr/bin/env bash

echo "List of cronjobs"
kubectl get cronjobs

echo ""

echo "List of jobs"
kubectl get jobs
