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
- kubectx / kubens
- watch (Optional)
- yq (optional)

Exec: `make install_tools` to install main tools tools.



### Auto-complete

https://minikube.sigs.k8s.io/docs/commands/completion/
https://kubernetes.io/docs/tasks/tools/install-kubectl/#enabling-shell-autocompletion

```
################################
##           ZSH               #
################################

# zsh completion minikube/kubectl
autoload -U +X compinit && compinit
source <(minikube completion zsh)
source <(kubectl completion zsh) 
```

```
################################
##           BASH  Ubuntu      #
################################

### Install bash-completion
# Bash Ubuntu +
sudo apt-get install bash-completion
```

```
################################
##           BASH  MacOS       #
################################
# Bash maC
brew install bash-completion@2
```

```
################################
##           BASH  Manjaro     #
################################
# Bash Arch/Manjaro
sudo pacman -S bash-completion
```

```
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

```
## Default options
minikube start
```

or

```
minikube start --alsologtostderr --v $K8_LOG_LEVEL -p $K8_PROFILE_NAME \
    --memory $K8_MINIK_RAM_MB --cpus $K8_MINIK_CPU_NUM --disk-size $K8_MINIK_DISK \
    --driver $K8_MINIKUBE_DRIVER --kubernetes-version $K8_API_VERSION
```

### Addons

List 
```
minikube -p workshop addons list
```

or

```
minikube addons enable metrics-server --v=$K8_LOG_LEVEL -p $K8_PROFILE_NAME
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
