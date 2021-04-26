#!/bin/bash

kubectl delete resourcequota/pods-low 
kubectl delete priorityclass.scheduling.k8s.io/low-prio 
kubectl delete pod/low-priority-1 
kubectl delete pod/low-priority-2 
