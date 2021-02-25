#!/bin/bash


### List PODS, create, list by namespace
kubectl get pods

kubectl get pods --namespace default

kubectl get pods -n workshop-ns

# create from yaml
kubectl apply -f ./practices/practice_2_1_pods.yaml

kubectl get pods workshop-ns

kubectl get pod mypod
kubectl get pod mypod -n workshop-ns

## List deployments, create

# List from all namespaces (-A) with extra information (-o wide) and waiting for changes (-w)
kubectl get deployments -A -o wide -w
# -o could be json, yaml, wide (to show more fields than standar), custom format, etc

# Create deploy from CLI
kubectl create deployment snowflake --image=k8s.gcr.io/serve_hostname  -n=workshop-ns --replicas=2
# Filter by labels
kubectl get pods -l app=snowflake -n=workshop-ns
# Describe
kubectl describe pods -l app=snowflake -n=workshop-ns
kubectl describe deployment snowflake -n=workshop-ns
# create from yaml
kubectl apply -f ./practices/practice_2_2_deployment.yaml

