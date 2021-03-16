#!/bin/bash


# Use the kubectl create configmap command to create ConfigMaps from directories, files, or literal values:
# Create the configmap from files
kubectl create configmap game-config-from-files -n workshop-ns \
    --from-file=practices/part3/samplefiles/ \
    --dry-run=client \
    --output=yaml

# Create the configmap from file like env vars
kubectl create configmap game-config-env-file -n workshop-ns \
    --from-env-file=practices/part3/samplefiles/game.properties \
    --dry-run=client \
    --output=yaml

# Create the configmap from literal like env vars
kubectl create configmap special-config -n workshop-ns \
    --from-literal=special.how=very --from-literal=special.type=charm \
    --dry-run=client \
    --output=yaml

# create the configmap & pod
kubectl apply -f ./practices/part3/practice_3_1_config.yaml

# List pods
kubectl get pods -n workshop-ns

# execute comand into pod to watch env vars (interactive terminal)
kubectl exec -ti  configmap-demo-pod -- sh

kubectl exec -n workshop-ns configmap-demo-pod -- env

# Excecute command to list and print files from configmap
kubectl exec -n workshop-ns configmap-demo-pod -- sh -c "ls /config/;cat /config/*"



#######################################################
### SECRETS
#######################################################
kubens workshop-ns

kubectl apply -f ./practices/part3/practice_3_2_secrets.yaml

kubectl exec -ti  secret-env-pod -- bash

kubectl exec -n workshop-ns secret-env-pod -- env
kubectl exec -n workshop-ns secret-env-pod -- ls

# Enter & keep in bash (interactive terminal)
kubectl exec -n workshop-ns secret-env-pod -it -- bash

# Excecute comand in bash and exit
kubectl exec -n workshop-ns secret-env-pod -- bash -c "ls /etc/foo; echo; cat /etc/foo/*"
