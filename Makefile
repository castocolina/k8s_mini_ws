export K8_PROFILE_NAME=workshop
export K8_LOG_LEVEL=2
	

tools: install

install: install_virt install_tools
	@bash scripts/part1_tools/n3_versions.sh

install_virt:
	@scripts/part1_tools/n1_virtualization.sh

install_tools:
	@scripts/part1_tools/n2_minikube.sh

boot: create
start: create
minikube: create
create:
	@bash scripts/part2_minik8s_start/start.sh

test_hello: test
test_ingress: test
test:
	@bash scripts/part2_minik8s_start/test_ingress.sh

install_crds:
	@bash scripts/part2_minik8s_start/install_ss_crd.sh

show_ip:
	@echo "minikube ip --v=$$K8_LOG_LEVEL -p $${K8_PROFILE_NAME}"; 
	@echo "$$(minikube ip --v=$$K8_LOG_LEVEL -p $${K8_PROFILE_NAME})";
	@echo "PATH HTTP: http://$$(minikube ip -p $${K8_PROFILE_NAME})";
	@echo "PATH HTTPS: https://$$(minikube ip -p $${K8_PROFILE_NAME})";

dashboard:
	minikube dashboard -p "$${K8_PROFILE_NAME}"

destroy:
	minikube delete -p "$${K8_PROFILE_NAME}"

stop:
	minikube stop -p "$${K8_PROFILE_NAME}"

services:
	minikube service list -p "$${K8_PROFILE_NAME}"

ssh:
	minikube ssh -p "$${K8_PROFILE_NAME}"
