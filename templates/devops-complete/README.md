# Complete DevOps Environment

All-in-one DevOps environment with every tool you need for daily work. This template combines tools from Kubernetes, Terraform, Cloud, Monitoring, GitOps, and Security into a single comprehensive environment.

## What's Included

### Container & Orchestration

- **Docker** - Container runtime
- **Docker Compose** - Multi-container applications
- **Kubernetes** - kubectl, helm, k9s, stern, kustomize, skaffold
- **Context Management** - kubectx, kubens

### Infrastructure as Code

- **Terraform** - Infrastructure provisioning
- **Validation** - tflint, tfsec, infracost
- **Ansible** - Configuration management
- **Packer** - Image building

### Cloud Providers

- **AWS** - AWS CLI v2
- **GCP** - Google Cloud SDK
- **Azure** - Azure CLI
- **DigitalOcean** - doctl

### GitOps

- **ArgoCD** - Declarative GitOps CD
- **FluxCD** - GitOps toolkit
- **Secrets** - SOPS, age, kubeseal

### Monitoring & Observability

- **Metrics** - Prometheus, Grafana, promtool
- **Logging** - Loki, logcli
- **Tracing** - OpenTelemetry Collector

### Security

- **Container Scanning** - Trivy
- **Secrets Management** - Vault
- **Signing** - Cosign
- **IaC Security** - Checkov
- **Secret Scanning** - Gitleaks
- **K8s Security** - Kubescape

### CI/CD

- **GitHub** - GitHub CLI
- **GitLab** - GitLab Runner
- **Local Testing** - act (GitHub Actions)

### Databases

- PostgreSQL, Redis, MongoDB clients

### Service Mesh

- Istio (istioctl), Linkerd

### Utilities

- jq, yq, curl, wget, make, httpie, git, fzf, ripgrep, bat, dive

## Quick Start

```bash
# Initialize in your project
nix flake init -t github:DevLayers/nix-config#devops-complete

# Enter the full environment
nix develop

# Or use specific sub-environments
nix develop .#k8s-only       # Just Kubernetes tools
nix develop .#infra-only     # Just Terraform/Cloud
nix develop .#minimal        # Lightweight essentials
```

## Available Environments

### `default` - Full DevOps Stack

Everything included. Use for comprehensive DevOps work.

```bash
nix develop
```

### `k8s-only` - Kubernetes Focus

kubectl, helm, k9s, stern, kustomize, argocd, flux, and utilities.

```bash
nix develop .#k8s-only
```

### `infra-only` - Infrastructure Focus

Terraform, Ansible, Packer, and all cloud CLIs.

```bash
nix develop .#infra-only
```

### `minimal` - Essential Tools Only

kubectl, helm, terraform, aws, docker - the bare minimum.

```bash
nix develop .#minimal
```

## Usage Examples

### Deploy to Kubernetes

```bash
# View cluster with K9s
k9s

# Apply manifests
kubectl apply -f examples/simple-deployment/

# Stream logs
stern my-app -n production

# Switch context
kctx production
kns my-namespace
```

### Manage Infrastructure

```bash
# Initialize Terraform
terraform init

# Plan changes
terraform plan

# Apply with security scanning
tfsec .
terraform apply

# Check costs
infracost breakdown --path .
```

### GitOps Deployment

```bash
# ArgoCD
argocd login <server>
argocd app sync my-app
argocd app get my-app

# FluxCD
flux bootstrap github --owner=myorg --repository=fleet
flux get all
flux reconcile source git flux-system
```

### Security Scanning

```bash
# Scan container images
trivy image nginx:latest

# Scan filesystem
trivy fs .

# IaC security
tfsec .
checkov -d .

# Secret scanning
gitleaks detect --source=.

# Kubernetes security
kubescape scan framework nsa
```

### Monitoring

```bash
# Start Prometheus
prometheus --config.file=prometheus.yml

# Start Grafana
grafana-server --homepath /usr/share/grafana

# Query Prometheus
promtool query instant http://localhost:9090 'up'

# View Loki logs
logcli query '{app="myapp"}' --since=1h
```

### Cloud Operations

```bash
# AWS
aws s3 ls
aws ec2 describe-instances

# GCP
gcloud compute instances list
gcloud container clusters list

# Azure
az vm list
az aks list
```

## Helper Commands

The environment includes helpful aliases and functions:

### Aliases

- `k` - kubectl
- `tf` - terraform
- `kns <namespace>` - Switch Kubernetes namespace
- `kctx <context>` - Switch Kubernetes context
- `logs <pod>` - Stream logs with stern

### Functions

- `devops-info` - Show current Kubernetes context, Terraform workspace, cloud config

```bash
# Check your current context
devops-info
```

## direnv Integration

For automatic environment activation:

```bash
# Copy example config
cp .envrc.example .envrc

# Edit with your preferences
vim .envrc

# Enable direnv
direnv allow
```

## Example Projects

See the `examples/` directory for sample configurations:

- **simple-deployment/** - Basic Kubernetes deployment
- **full-stack/** - Complete application stack with monitoring

## Makefile Commands

```bash
make help      # Show available commands
make init      # Initialize infrastructure
make deploy    # Deploy application
make test      # Run tests
make destroy   # Destroy infrastructure
make clean     # Clean build artifacts
```

## Learn More

- [DevOps Learning Path](../../DEVOPS-LEARNING-PATH.md) - 12-week structured curriculum
- [Main Templates README](../../templates/README.md) - All available templates

## Tips

1. **Start with `minimal`** for quick tasks, use `default` for full work
2. **Use `k9s`** for visual Kubernetes management
3. **Run security scans** before applying infrastructure changes
4. **Use `devops-info`** to check current context before operations
5. **Leverage aliases** (k, tf, logs) for faster workflow

## Contributing

Found an issue or want to add a tool? Submit a PR or open an issue!

## License

See [LICENSE](../../../LICENSE) file.
