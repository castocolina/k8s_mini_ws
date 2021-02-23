#!/bin/bash

# create the configmap & pod
kubectl apply -f ./practices/practice_3_1_config.yaml

# List pods
kubectl get pods -n workshop-ns

# execute comand into pod to watch env vars
kubectl exec -ti  secret-env-pod -- bash

kubectl exec -n workshop-ns configmap-demo-pod -- env

# Excecute command to list and print files from configmap
kubectl exec -n workshop-ns configmap-demo-pod -- sh -c "ls /config/;cat /config/*"



#######################################################
### SECRETS
#######################################################

kubectl apply -f ./practices/practice_3_2_secrets.yaml

kubectl exec -ti  secret-env-pod -- bash

kubectl exec -n workshop-ns secret-env-pod -- env
kubectl exec -n workshop-ns secret-env-pod -- ls
kubectl exec -n workshop-ns secret-env-pod -- bash -c "ls /etc/foo; echo; cat /etc/foo/*"
