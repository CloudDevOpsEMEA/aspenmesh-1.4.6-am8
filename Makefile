# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# ASPENMESH_NAMESPACE=istio-system
# ASPENMESH_NAMESPACE_SPEC=./kubernetes/namespace-istio-system.yaml
ASPENMESH_NAMESPACE=aspenmesh
ASPENMESH_NAMESPACE_SPEC=./kubernetes/namespace-aspenmesh.yaml

OPENEBS_NAMESPACE=openebs
OPENEBS_NAMESPACE_SPEC=./kubernetes/namespace-openebs.yaml

BOOKINFO_NAMESPACE=bookinfo
BOOKINFO_NAMESPACE_SPEC=./kubernetes/namespace-bookinfo.yaml

ISTIO_SYSTEM_NAMESPACE=istio-system
ISTIO_SYSTEM_NAMESPACE_SPEC=./kubernetes/namespace-istio-system.yaml

PRIVATE_KEY_CERT=/home/ubuntu/aspen-demo-private-key.pem
WILDCARD_CERT=/home/ubuntu/aspen-demo-wildcard-cert.pem

KUBE_DASHBOARD_SPEC=./kubernetes/dashboard.yaml

HELM_ISTIO_INIT=./install/kubernetes/helm/istio-init
HELM_ASPENMESH=./install/kubernetes/helm/aspenmesh

ASPENMESH_LOCAL_VALUES=${HELM_ASPENMESH}/values-aspenmesh-udf.yaml

##### Istio init #####
helm_init_istio_crd: ## Initialise istio CRDs
	kubectl apply -f ${ASPENMESH_NAMESPACE_SPEC}
	helm install istio-init ${HELM_ISTIO_INIT} --namespace ${ASPENMESH_NAMESPACE}

helm_remove_istio_crd: ## Remove istio CRDs
	helm uninstall istio-init --namespace ${ASPENMESH_NAMESPACE}


##### Aspenmesh ######
helm_install_aspenmesh: ## Install aspenmesh
	kubectl apply -f ${ASPENMESH_NAMESPACE_SPEC}
	helm install aspenmesh ${HELM_ASPENMESH} --namespace ${ASPENMESH_NAMESPACE} --values ${ASPENMESH_LOCAL_VALUES} --timeout 300s

helm_upgrade_aspenmesh: ## Upgrade aspenmesh
	kubectl apply -f ${ASPENMESH_NAMESPACE_SPEC}
	helm upgrade aspenmesh ${HELM_ASPENMESH} --namespace ${ASPENMESH_NAMESPACE} --values ${ASPENMESH_LOCAL_VALUES}

helm_remove_aspenmesh: ## Remove aspenmesh
	helm uninstall aspenmesh --namespace ${ASPENMESH_NAMESPACE}
	kubectl delete -f ${ASPENMESH_NAMESPACE_SPEC}


##### OpenEBS #####
helm_install_openebs: ## Install openebs
	kubectl apply -f ${OPENEBS_NAMESPACE_SPEC}
	helm install --namespace ${OPENEBS_NAMESPACE} openebs stable/openebs --version 1.9.0

helm_remove_openebs: ## Remove openebs
	helm install --namespace ${OPENEBS_NAMESPACE} openebs stable/openebs --version 1.9.0
	kubectl delete -f ${OPENEBS_NAMESPACE_SPEC}

##### Ingress certificates #####
install_certificates: ## Installs the certificates for secure ingress
	kubectl apply -f ${ISTIO_SYSTEM_NAMESPACE_SPEC}
	kubectl create secret tls --namespace aspenmesh bookinfo-bookinfo --key ${PRIVATE_KEY_CERT} --cert ${WILDCARD_CERT}

##### Bookinfo Sample Application #####
kubernetes_install_bookinfo: ## Install bookinfo sample application
	kubectl apply -f ${BOOKINFO_NAMESPACE_SPEC}
	kubectl apply --namespace ${BOOKINFO_NAMESPACE} -f samples/aspenmesh/pullsecret.yaml
	kubectl apply --namespace ${BOOKINFO_NAMESPACE} -f samples/bookinfo/platform/kube/bookinfo.yaml
	kubectl apply --namespace ${BOOKINFO_NAMESPACE} -f samples/aspenmesh/bookinfo-traffic-generator.yaml
	kubectl apply --namespace ${BOOKINFO_NAMESPACE} -f kubernetes/bookinfo-secure-ingress.yaml

kubernetes_remove_bookinfo: ## Remove bookinfo sample application
	kubectl delete --namespace ${BOOKINFO_NAMESPACE} -f kubernetes/bookinfo-secure-ingress.yaml
	kubectl delete --namespace ${BOOKINFO_NAMESPACE} -f samples/aspenmesh/bookinfo-traffic-generator.yaml
	kubectl delete --namespace ${BOOKINFO_NAMESPACE} -f samples/bookinfo/platform/kube/bookinfo.yaml
	kubectl delete --namespace ${BOOKINFO_NAMESPACE} -f samples/aspenmesh/pullsecret.yaml
	kubectl delete -f ${BOOKINFO_NAMESPACE_SPEC}


##### Kubernetes dashboard #####
kubernetes_install_dashboard:: ## Install kubernetes dashboard
	kubectl apply --namespace kube-system -f ${KUBE_DASHBOARD_SPEC}

kubernetes_remove_dashboard: ## Remove kubernetes dashboard
	kubectl delete --namespace kube-system -f ${KUBE_DASHBOARD_SPEC}


##### Install Nginx+ #####
install_nginx_plus: ## Install Nginx+
	sudo cp -a /etc/nginx /etc/nginx-plus-backup
	sudo cp -a /var/log/nginx /var/log/nginx-plus-backup
	sudo mkdir -p /etc/ssl/nginx
	sudo cp ./nginx/nginx-repo.key /etc/ssl/nginx
	sudo cp ./nginx/nginx-repo.crt /etc/ssl/nginx
	sudo apt-key add ./nginx/nginx_signing.key
	printf "deb https://plus-pkgs.nginx.com/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-plus.list
	sudo wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90nginx
	sudo apt-get -y update
	sudo apt-get -y install nginx-plus
	nginx -v



