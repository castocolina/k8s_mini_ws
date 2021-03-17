#!/bin/bash

https://minikube.sigs.k8s.io/docs/commands/completion/
https://kubernetes.io/docs/tasks/tools/install-kubectl/#enabling-shell-autocompletion

################################
##           ZSH               #
################################

# zsh completion minikube/kubectl
autoload -U +X compinit && compinit
source <(minikube completion zsh)
source <(kubectl completion zsh) 


################################
##           BASH              #
################################

### Install bash-completion
# Bash Ubuntu +
sudo apt-get install bash-completion
# Bash maC
brew install bash-completion@2
# Bash Arch/Manjaro
sudo pacman -S bash-completion

## Load bash_completion
source /usr/share/bash-completion/bash_completion

# bash completion minikube/kubectl
source <(minikube completion bash)
source <(kubectl completion bash) 
