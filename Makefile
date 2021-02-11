
tools:
	@bash part1_tools/n1_virtualization.sh
	@bash part1_tools/n2_minikube.sh
	@bash part1_tools/n3_versions.sh

boot: create
start: create
minikube: create
create:
	@bash part2_minik8s_start/start.sh

show_ip:
	K8_PROFILE_NAME=workshop; \
	@echo "minikube ip --v=$$K8_LOG_LEVEL -p $$K8_PROFILE_NAME"; \
	@echo "$(minikube ip --v=$$K8_LOG_LEVEL -p $$K8_PROFILE_NAME)"; \
	@echo "PATH HTTP: http://$(minikube ip -p $$K8_PROFILE_NAME)"; \
	@echo "PATH HTTPS: https://$(minikube ip -p $$K8_PROFILE_NAME)";

dashboard:
	minikube dashboard -p workshop

stop:
	minikube stop -p workshop
