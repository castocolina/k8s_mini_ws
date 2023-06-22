# k8s minikube whorkshop

TOC

Presentation https://docs.google.com/presentation/d/1bZDzrIPnhK8qVwNvo8hw524POwHdrv1RUkoVeQWcNuQ/edit?usp=sharing

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
minikube dashboard -p $K8_PROFILE_NAME
```

or

``` bash
make dashboard
```

## Nodes & Namespaces

Kubernetes runs your workload by placing containers into Pods to run on **Nodes**. A node may be a virtual or physical machine, depending on the cluster.


Typically you have several nodes in a cluster; in a learning or resource-limited environment, you might have just one.


Kubernetes supports multiple virtual clusters backed by the same physical cluster. These virtual clusters are called namespaces.


**Namespaces** provide a scope for names. Names of resources need to be unique within a namespace, but not across namespaces. Namespaces cannot be nested inside one another and each Kubernetes resource can only be in one namespace.

![Nodes & Namespaces](images/k8_namespaces.png)

### Practice 1 - Namespaces

scripts/part3_practices/practice_1_namespaces.sh

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
