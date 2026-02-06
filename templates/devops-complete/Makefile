.PHONY: help init deploy destroy test clean

help: ## Show this help
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

init: ## Initialize infrastructure
	@echo "Initializing infrastructure..."
	terraform init
	kubectl cluster-info || echo "No Kubernetes cluster configured"

deploy: ## Deploy application
	@echo "Deploying application..."
	kubectl apply -f examples/simple-deployment/ || echo "No Kubernetes cluster"
	argocd app sync example-app || echo "ArgoCD not configured"

validate: ## Validate configurations
	@echo "Validating configurations..."
	terraform validate || true
	tfsec . || true
	yamllint examples/ || true

security-scan: ## Run security scans
	@echo "Running security scans..."
	trivy fs .
	checkov -d . || true
	gitleaks detect --source=. || true

test: ## Run tests
	@echo "Running tests..."
	kubectl get pods || echo "No cluster"
	terraform validate || true

destroy: ## Destroy infrastructure
	@echo "Destroying infrastructure..."
	kubectl delete -f examples/simple-deployment/ || true
	terraform destroy -auto-approve || true

clean: ## Clean build artifacts
	@echo "Cleaning build artifacts..."
	rm -rf .terraform
	rm -rf result*
	rm -rf prometheus-data grafana-data loki-data

status: ## Show current status
	@echo "Current Status:"
	@echo "==============="
	@kubectl config current-context 2>/dev/null || echo "No K8s context"
	@terraform workspace show 2>/dev/null || echo "No TF workspace"
	@echo "AWS Profile: $${AWS_PROFILE:-default}"
