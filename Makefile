CLUSTER_NAME=k8s-cluster
CLUSTER_EXISTS=$(shell kind get clusters | grep $(CLUSTER_NAME))

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## Ajuda
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

define get_kind_config_file
# Define config file
cat <<EOF $(KIND_CONFIG_FILE_NAME)
# kind.config.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
    - |
      kind: InitConfiguration
      nodeRegistration:
        kubeletExtraArgs:
          node-labels: "ingress-ready=true" 
- role: worker
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
    listenAddress: "0.0.0.0"
  - containerPort: 443
    hostPort: 443
    protocol: TCP
    listenAddress: "0.0.0.0"
EOF
endef
export KIND_CONFIG_FILE_CREATOR = $(value get_kind_config_file)

create-cluster: ## Cria cluster Kubernetes Kind 
     ifneq ($(CLUSTER_EXISTS), $(CLUSTER_NAME))
		  @ eval "$$KIND_CONFIG_FILE_CREATOR" | kind create cluster --name $(CLUSTER_NAME) --config=-
		  @echo "#### Installing ingress-nginx and metrics server####"
		  kubectl apply --filename https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
		  kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
	  else
	  	kind get clusters
    endif

display-cluster: ## Exibe cluster Kubernetes Kind
	kind get clusters

delete-cluster: ## Exclui cluster Kubernetes Kind
	kind delete cluster --name ${CLUSTER_NAME}
	docker system prune -f
