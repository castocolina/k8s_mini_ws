BASEDIR=$(dirname "$0")
source $BASEDIR/../commons/common.sh
source $BASEDIR/../commons/colors.sh

echo
kubectx ${K8_PROFILE_NAME}
echo

echo
# Install Bitnami SealedSecret CRD (for k8s >= 1.7)
release=$(get_github_latest_release "bitnami-labs/sealed-secrets" "v0.20.1")
release_short="${release:1}"
URL=https://github.com/bitnami-labs/sealed-secrets/releases/download/$release/controller.yaml
echo "$URL"
minikube -p "${K8_PROFILE_NAME}" kubectl -- apply -f $URL

wait_time 5
minikube -p ${K8_PROFILE_NAME} kubectl -- get deployment sealed-secrets-controller -n kube-system
wait_for_enter
text_w_color "Create sample secret \n" "Yellow"

# Create a json/yaml-encoded Secret somehow:
# (note use of `--dry-run` - this is just a local file!)

text_w_color "\nEnter the secret value > " "BRed" "On_BBlack"
read -s foo_value
foo_value=${foo_value:-bar}
echo
echo -n "${foo_value}" | minikube -p ${K8_PROFILE_NAME} \
    kubectl -- create secret generic mysecret --dry-run=client --from-file=foo=/dev/stdin \
    -o json >tmp/mysecret.json

# This is the important bit:
# (note default format is json!)
kubeseal <tmp/mysecret.json >tmp/mysealedsecret.json

# At this point mysealedsecret.json is safe to upload to Github,
# post on Twitter, etc.

# Eventually:
minikube -p ${K8_PROFILE_NAME} kubectl -- create -f tmp/mysealedsecret.json

# Profit!
minikube -p ${K8_PROFILE_NAME} kubectl -- get secret mysecret

MY_SECRET_B64=$(minikube -p ${K8_PROFILE_NAME} kubectl -- get secret mysecret -o jsonpath='{.data.foo}')
MY_SECRET_PLAIN=$(echo ${MY_SECRET_B64} | base64 -i --decode)


wait_for_enter
echo
text_w_color "The value id: " "Green"
echo "$MY_SECRET_PLAIN"

echo; echo;
minikube -p ${K8_PROFILE_NAME} kubectl -- delete -f tmp/mysealedsecret.json

