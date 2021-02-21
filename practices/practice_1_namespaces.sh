#!/bin/sh

kubectl get namespaces

kubectl get namespaces default

kubectl describe namespaces default

kubectl create namespace example-ns-1

kubectl describe namespaces example-ns-1

# Warning: This deletes everything under the namespace!
kubectl delete namespaces example-ns-1

## Create the development namespace using kubectl
kubectl create -f https://k8s.io/examples/admin/namespace-dev.json

kubectl create -f ./practices/practice_1_namespaces.yaml
kubectl create -f ./practices/practice_1_namespaces.yaml
kubectl apply -f ./practices/practice_1_namespaces.yaml

# dry-run
kubectl create -f ./practices/practice_1_namespaces.yaml --dry-run=client

