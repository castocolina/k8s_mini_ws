#!/bin/sh

# create the configmap & pod
kubectl apply -f ./practices/practice_3_1_config.yaml

# List pods
kubectl get pods -n workshop-ns

# exceute comand into pod to watch env vars
kubectl exec -n workshop-ns configmap-demo-pod -- env

# Excecute command to list and print files from configmap
kubectl exec -n workshop-ns configmap-demo-pod -- sh -c "ls /config/;cat /config/*"


