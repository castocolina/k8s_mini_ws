# k8s minikube whorkshop

## Table of Contents

1. [Create our cluster](#create-our-content)
2. [Nodes & Namespaces](#nodes--namespaces)
2. [Pods, ReplicaSet & Deployments](#pods-replicaset--deployments)

<!--

Presentation https://docs.google.com/presentation/d/1bZDzrIPnhK8qVwNvo8hw524POwHdrv1RUkoVeQWcNuQ/edit?usp=sharing
 -->
## Create our cluster

### Tools

For virtualization we need any driver. Check at https://minikube.sigs.k8s.io/docs/drivers/\
Exec: `make install_virt` to install kvm for ubuntu or hyperkit for macOS.

For commands we need some tools:
- Minikube
- Kubectl
- kubeseal
- Optionals: yq / jq
- Optionals: kubectx / kubens
- Optionals: watch / [kube-ps1](https://github.com/jonmosco/kube-ps1/blob/master/img/kube-ps1.gif)

Exec: `make install_tools` to install main tools tools.



### Auto-complete (Optional)

https://minikube.sigs.k8s.io/docs/commands/completion/
https://kubernetes.io/docs/tasks/tools/install-kubectl/#enabling-shell-autocompletion

``` zsh
################################
##           ZSH               #
################################

# zsh completion minikube/kubectl
autoload -U +X compinit && compinit
source <(minikube completion zsh)
source <(kubectl completion zsh) 
```

``` bash
################################
##           BASH  Ubuntu      #
################################

### Install bash-completion
# Bash Ubuntu +
sudo apt-get install bash-completion
```

``` bash
################################
##           BASH  MacOS       #
################################
# Bash maC
brew install bash-completion@2
```

``` bash
################################
##           BASH  Manjaro     #
################################
# Bash Arch/Manjaro
sudo pacman -S bash-completion
```

``` bash
################################
##           BASH              #
################################
## Load bash_completion
source /usr/share/bash-completion/bash_completion

# bash completion minikube/kubectl
source <(minikube completion bash)
source <(kubectl completion bash)
```

### Create Minikube Virtual Machine

``` bash
## Default options
minikube start
```

or

``` bash
minikube start --alsologtostderr --v $K8_LOG_LEVEL -p $K8_PROFILE_NAME \
    --memory $K8_MINIK_RAM_MB --cpus $K8_MINIK_CPU_NUM --disk-size $K8_MINIK_DISK \
    --driver $K8_MINIKUBE_DRIVER --kubernetes-version $K8_API_VERSION
```

### Addons

List 
``` bash
minikube -p workshop addons list
```

or

``` bash
minikube addons enable metrics-server --v=$K8_LOG_LEVEL -p $K8_PROFILE_NAME
```

### Dashboard

``` bash
make dashboard
```

or

``` bash
minikube dashboard -p $K8_PROFILE_NAME
```

## Nodes & Namespaces

Kubernetes runs your workload by placing containers into Pods to run on **Nodes**. A node may be a virtual or physical machine, depending on the cluster.


Typically you have several nodes in a cluster; in a learning or resource-limited environment, you might have just one.


Kubernetes supports multiple virtual clusters backed by the same physical cluster. These virtual clusters are called namespaces.


**Namespaces** provide a scope for names. Names of resources need to be unique within a namespace, but not across namespaces. Namespaces cannot be nested inside one another and each Kubernetes resource can only be in one namespace.

![Nodes & Namespaces](images/k8_namespaces.png)

### Practice 1 - Namespaces

Recomendations: Use `kubens`.

> scripts/part3_practices/practice_1_namespaces.sh

``` bash

## list namespaces
kubectl get namespaces

## The default namespace
kubectl get namespaces default

kubectl describe namespaces default

# Create a namespace
kubectl create namespace example-ns-1

# Show namespace information
kubectl describe namespaces example-ns-1

# Warning: This deletes everything under the namespace!
kubectl delete namespaces example-ns-1

## Create the development namespace using kubectl
kubectl create -f https://k8s.io/examples/admin/namespace-dev.json
kubectl delete -f https://k8s.io/examples/admin/namespace-dev.json
curl -L https://k8s.io/examples/admin/namespace-dev.json

kubectl create -f ./scripts/part3_practices/practice_1_namespaces.yaml
kubectl apply -f ./scripts/part3_practices/practice_1_namespaces.yaml

# dry-run
kubectl create -f ./scripts/part3_practices/practice_1_namespaces.yaml --dry-run=client

kubectl create -f ./scripts/part3_practices/practice_1_namespaces.yaml --dry-run=client -o json

```

Explore the files, play, enjoy! 😊

## Pods, ReplicaSet & Deployments

### Pods

**Pods** are the smallest deployable units of computing that you can create and manage in Kubernetes.


A **Pod** (as in a pod of whales or pea pod) **is a group of one or more containers, with shared storage and network resources, and a specification for how to run the containers**. A Pod models an application-specific "logical host": it contains one or more application containers which are relatively tightly coupled. In non-cloud contexts, applications executed on the same physical or virtual machine are analogous to cloud applications executed on the same logical host.


Usually you don't need to create Pods directly, even singleton Pods. Instead, create them using workload resources such as Deployment or Job.


Pods in a Kubernetes cluster are used in two main ways:

- Pods that run a single container
- Pods that run multiple containers that need to work together

![Pod](images/pod.svg)

### ReplicaSet

A **ReplicaSet**'s purpose is to maintain a stable set of replica Pods running at any given time. As such, it is often used to guarantee the availability of a specified number of identical Pods.

A **ReplicaSet** <u>is defined with fields</u>, including a selector that specifies how to identify Pods it can acquire, a number of replicas indicating how many Pods it should be maintaining, and a pod template specifying the data of new Pods it should create to meet the number of replicas criteria. A ReplicaSet then fulfills its purpose by creating and deleting Pods as needed to reach the desired number. When a ReplicaSet needs to create new Pods, it uses its Pod template.

![Replicaset](images/Replicaset.png)

### Deployment

A **Deployment** provides declarative updates for Pods and ReplicaSets.


You can define Deployments to create new ReplicaSets, or to remove existing Deployments and adopt all their resources with new Deployments.

![Deployment](images/Deployment.png)

### Practice 2 - Pods & Deployments

> scripts/part3_practices/practice_2_0_pods_deployments.sh

``` bash

### List PODS, create, list by namespace
kubectl get pods

## Now try with watch command in diferent terminal
watch kubectl get pods --namespace default
watch kubectl get pods -n workshop-ns

# create from yaml
kubectl apply -f ./scripts/part3_practices/practice_2_1_pods.yaml

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
kubectl apply -f ./scripts/part3_practices/practice_2_2_deployment.yaml
```

## References

- https://minikube.sigs.k8s.io/docs/drivers/

- https://github.com/bitnami-labs/sealed-secrets

- https://github.com/jonmosco/kube-ps1

##### Minikube Start
- https://minikube.sigs.k8s.io/docs/start/

##### Minikube Commands
- https://minikube.sigs.k8s.io/docs/commands/

##### Completion
- https://kubernetes.io/docs/tasks/tools/install-kubectl/#enabling-shell-autocompletion
- https://minikube.sigs.k8s.io/docs/commands/completion/

##### Others
- https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/#create-a-pod-that-uses-your-secret
