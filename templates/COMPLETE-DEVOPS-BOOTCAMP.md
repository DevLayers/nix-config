# Complete DevOps Engineer Bootcamp 🚀

**From Zero to Job-Ready in 8 Weeks (Intensive)**

A comprehensive, project-based intensive bootcamp that transforms you into a production-ready DevOps Engineer through hands-on learning and real-world projects. Designed for dedicated learners with 12-13 hours daily availability.

---

## 📋 Table of Contents

- [Bootcamp Overview](#bootcamp-overview)
- [Prerequisites](#prerequisites)
- [Your Learning Environment](#your-learning-environment)
- [Phase 1: Foundation (Weeks 1-3)](#phase-1-foundation-weeks-1-3)
- [Phase 2: Production Skills (Weeks 4-5)](#phase-2-production-skills-weeks-4-5)
- [Phase 3: Advanced & Portfolio (Weeks 6-8)](#phase-3-advanced--portfolio-weeks-6-8)
- [Career Preparation](#career-preparation)
- [Daily Routine](#daily-routine)
- [Progress Tracking](#progress-tracking)

---

## 🎯 Bootcamp Overview

### What You'll Build

By the end of this bootcamp, you will have:

1. ✅ **10+ Production-Grade Projects** in your portfolio
2. ✅ **Personal Infrastructure** running 24/7
3. ✅ **Open Source Contributions** to CNCF projects
4. ✅ **Technical Blog** with 20+ DevOps articles
5. ✅ **Job-Ready Resume** with measurable achievements
6. ✅ **Interview Confidence** with real-world experience

### Time Commitment

- **Total Duration**: 8 weeks (2 months intensive)
- **Hours per Day**: 12-13 hours (full-time commitment)
- **Total Hours**: ~700 hours (same depth, faster pace)
- **Schedule**: Daily intensive learning (no days off)
- **Best for**: Full-time students, career switchers, dedicated learners

### Success Metrics

```
After 8 weeks, you will be able to:

✅ Deploy production applications to Kubernetes
✅ Write Infrastructure as Code with Terraform
✅ Build complete CI/CD pipelines
✅ Set up monitoring and observability
✅ Debug distributed systems
✅ Respond to production incidents
✅ Pass technical interviews
✅ Get hired as a DevOps Engineer
```

---

## 📚 Prerequisites

### Required Knowledge (Start Here)

```bash
✅ Basic Linux commands (cd, ls, grep, find)
✅ Basic programming in any language
✅ Git basics (clone, commit, push, pull)
✅ Understanding of web applications (frontend/backend)
✅ Comfortable with command line
```

### Setup (Day 0)

```bash
# 1. Install Nix (if not already installed)
sh <(curl -L https://nixos.org/nix/install) --daemon

# 2. Enable flakes
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

# 3. Clone this repository
git clone https://github.com/DevLayers/nix-config
cd nix-config

# 4. Test templates
./scripts/test-templates.sh

# 5. Create your learning workspace
mkdir -p ~/devops-bootcamp
cd ~/devops-bootcamp
```

### Accounts You'll Need

```bash
# Free tier is sufficient for all projects
✅ GitHub Account (free)
✅ AWS Account (12 months free tier - primary cloud)
✅ Docker Hub (free)
✅ LinkedIn (for networking)

Note: This bootcamp focuses on AWS. You can optionally add
other cloud providers later, but AWS is the industry standard.
```

---

## 🎓 Your Learning Environment

### The Templates You'll Use

```bash
# Core templates for this bootcamp:
devops-complete     # All-in-one DevOps environment
kubernetes          # Container orchestration
terraform           # Infrastructure as Code
cloud               # AWS CLI and tools (primary cloud)
cicd                # CI/CD pipelines
monitoring          # Observability stack
gitops              # GitOps workflows
sre                 # Site Reliability Engineering
secops              # Security operations
```

### Setup Your First Environment

```bash
cd ~/devops-bootcamp
nix flake init -t github:DevLayers/nix-config#devops-complete
nix develop

# You now have 50+ DevOps tools ready to use!
```

---

## 🚀 Phase 1: Foundation (Weeks 1-3)

**Goal**: Master core DevOps tools and build your first projects
**Duration**: 3 weeks (252 hours total)
**Pace**: Fast and intensive

---

### Week 1, Days 1-2: Infrastructure as Code Fundamentals

**Learning Objectives:**

- Understand Infrastructure as Code concepts
- Master Terraform basics
- Deploy cloud infrastructure
- Manage state and modules

#### 📖 Theory (4 hours - Day 1 morning)

```bash
# Topics to study:
1. What is Infrastructure as Code?
2. Terraform architecture and workflow
3. Providers, resources, data sources
4. State management and backends
5. Modules and reusability
6. Best practices and conventions
```

**Resources:**

- HashiCorp Terraform Tutorials (free)
- Terraform Documentation
- YouTube: "Terraform in 100 Seconds" by Fireship

#### 🛠️ Project 1.1: AWS VPC with Terraform (20 hours - Days 1-2)

**Create a production-ready VPC infrastructure**

```bash
# Setup
cd ~/devops-bootcamp/week1-terraform-vpc
nix flake init -t github:DevLayers/nix-config#terraform
nix develop
```

**Project Structure:**

```
week1-terraform-vpc/
├── main.tf              # VPC, subnets, route tables
├── variables.tf         # Input variables
├── outputs.tf           # Output values
├── terraform.tfvars     # Variable values
├── modules/
│   ├── vpc/
│   ├── security-groups/
│   └── ec2/
└── README.md
```

**Requirements:**

```hcl
# main.tf
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "your-terraform-state"
    key    = "vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}

# Create VPC
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  environment        = var.environment
}

# Create Security Groups
module "security_groups" {
  source = "./modules/security-groups"

  vpc_id      = module.vpc.vpc_id
  environment = var.environment
}

# Create EC2 instances
module "web_servers" {
  source = "./modules/ec2"

  instance_count     = var.web_server_count
  instance_type      = var.instance_type
  subnet_ids         = module.vpc.public_subnet_ids
  security_group_ids = [module.security_groups.web_sg_id]

  tags = {
    Environment = var.environment
    Project     = "DevOps Bootcamp"
  }
}
```

**Tasks:**

1. ✅ Create VPC with 3 availability zones
2. ✅ Set up public and private subnets
3. ✅ Configure NAT Gateway and Internet Gateway
4. ✅ Create route tables and associations
5. ✅ Set up security groups (web, app, database)
6. ✅ Deploy 2 EC2 instances in public subnets
7. ✅ Use remote state backend (S3)
8. ✅ Create reusable modules
9. ✅ Run security scan with `tfsec`
10. ✅ Generate documentation with `terraform-docs`

**Validation:**

```bash
# Initialize and validate
terraform init
terraform validate
terraform fmt -check

# Security scan
tfsec .

# Plan and apply
terraform plan -out=tfplan
terraform apply tfplan

# Test
aws ec2 describe-instances --region us-east-1

# Generate docs
terraform-docs markdown . > README.md

# Destroy (save costs)
terraform destroy
```

**Success Criteria:**

- ✅ Infrastructure deploys successfully
- ✅ No security issues from tfsec
- ✅ State stored in S3 backend
- ✅ Modules are reusable
- ✅ Documentation is complete

#### 📝 Deliverable

Create a blog post: "Building Production VPC on AWS with Terraform"

**Include:**

- Architecture diagram
- Code snippets
- Lessons learned
- Cost optimization tips

---

### Week 1, Days 3-5: Container Fundamentals & Kubernetes

**Learning Objectives:**

- Master Docker containerization
- Understand Kubernetes architecture
- Deploy applications to Kubernetes
- Manage pods, deployments, services

#### 📖 Theory (6 hours - Day 3)

```bash
# Topics:
1. Containers vs VMs
2. Docker architecture
3. Kubernetes components (control plane, nodes)
4. Pods, Deployments, Services, ConfigMaps, Secrets
5. Namespaces and RBAC
6. Ingress and networking
```

**Resources:**

- Docker Documentation
- Kubernetes official tutorials
- "Kubernetes Crash Course" by TechWorld with Nana

#### 🛠️ Project 1.2: Full-Stack App on Kubernetes (30 hours - Days 3-5)

**Deploy a complete 3-tier application to Kubernetes**

```bash
# Setup
cd ~/devops-bootcamp/week2-k8s-fullstack
nix flake init -t github:DevLayers/nix-config#kubernetes
nix develop

# Create local cluster
kind create cluster --name bootcamp --config kind-config.yaml
```

**Application Architecture:**

```
┌─────────────────────────────────────────────────────────┐
│                    Ingress (NGINX)                      │
│                  app.bootcamp.local                     │
└────────────────────┬────────────────────────────────────┘
                     │
         ┌───────────┴───────────┐
         │                       │
    ┌────▼─────┐          ┌─────▼────┐
    │ Frontend │          │ Backend  │
    │  React   │          │   API    │
    │ (3 pods) │◄────────►│ (Node.js)│
    └──────────┘          │ (3 pods) │
                          └─────┬────┘
                                │
                          ┌─────▼─────┐
                          │PostgreSQL │
                          │(StatefulSet)│
                          └───────────┘
```

**Project Structure:**

```
week2-k8s-fullstack/
├── app/
│   ├── frontend/          # React application
│   ├── backend/           # Node.js API
│   └── Dockerfile         # Multi-stage builds
├── k8s/
│   ├── namespace.yaml
│   ├── frontend/
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   └── configmap.yaml
│   ├── backend/
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   ├── configmap.yaml
│   │   └── secret.yaml
│   ├── database/
│   │   ├── statefulset.yaml
│   │   ├── service.yaml
│   │   └── pvc.yaml
│   ├── ingress.yaml
│   └── kustomization.yaml
├── kind-config.yaml
└── README.md
```

**Frontend Deployment Example:**

```yaml
# k8s/frontend/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: bootcamp
  labels:
    app: frontend
    tier: presentation
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
        tier: presentation
    spec:
      containers:
        - name: frontend
          image: your-dockerhub/bootcamp-frontend:v1.0.0
          ports:
            - containerPort: 80
              name: http
          env:
            - name: REACT_APP_API_URL
              valueFrom:
                configMapKeyRef:
                  name: frontend-config
                  key: api_url
          resources:
            requests:
              memory: "128Mi"
              cpu: "100m"
            limits:
              memory: "256Mi"
              cpu: "200m"
          livenessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 10
            periodSeconds: 10
          readinessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 5
            periodSeconds: 5
---
apiVersion: v1
kind: Service
metadata:
  name: frontend
  namespace: bootcamp
spec:
  selector:
    app: frontend
  ports:
    - port: 80
      targetPort: 80
  type: ClusterIP
```

**Tasks:**

1. ✅ Create frontend (React/Vue/Svelte)
2. ✅ Create backend API (Node.js/Go/Python)
3. ✅ Write multi-stage Dockerfiles
4. ✅ Set up PostgreSQL StatefulSet
5. ✅ Create all K8s manifests
6. ✅ Configure Ingress with TLS
7. ✅ Set up ConfigMaps and Secrets
8. ✅ Implement health checks (liveness/readiness)
9. ✅ Configure resource limits
10. ✅ Deploy with rolling updates

**Validation:**

```bash
# Build and push images
docker build -t your-dockerhub/bootcamp-frontend:v1.0.0 app/frontend
docker build -t your-dockerhub/bootcamp-backend:v1.0.0 app/backend
docker push your-dockerhub/bootcamp-frontend:v1.0.0
docker push your-dockerhub/bootcamp-backend:v1.0.0

# Apply manifests
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/database/
kubectl apply -f k8s/backend/
kubectl apply -f k8s/frontend/
kubectl apply -f k8s/ingress.yaml

# Check status
kubectl get all -n bootcamp
kubectl get pods -n bootcamp -w

# Test application
curl -H "Host: app.bootcamp.local" http://localhost

# Use K9s for monitoring
k9s -n bootcamp

# Check logs
stern -n bootcamp frontend
stern -n bootcamp backend

# Describe resources
kubectl describe deployment frontend -n bootcamp
```

**Success Criteria:**

- ✅ All pods running and healthy
- ✅ Application accessible via Ingress
- ✅ Database persists data across pod restarts
- ✅ Rolling updates work without downtime
- ✅ Health checks pass

#### 📝 Deliverable

Blog post: "Deploying a Production-Grade Full-Stack App to Kubernetes"

---

### Week 2, Days 1-2: CI/CD Pipeline

**Learning Objectives:**

- Build automated CI/CD pipelines
- Implement security scanning
- Deploy with GitHub Actions
- Container registry management

#### 🛠️ Project 1.3: Complete CI/CD Pipeline (24 hours - Days 1-2)

**Create full automation from commit to production**

```bash
cd ~/devops-bootcamp/week3-cicd-pipeline
nix flake init -t github:DevLayers/nix-config#cicd
nix develop
```

**Pipeline Architecture:**

```
┌──────────┐      ┌──────────┐      ┌──────────┐      ┌──────────┐
│   Git    │─────▶│  Build   │─────▶│   Test   │─────▶│ Security │
│  Push    │      │ & Lint   │      │          │      │  Scan    │
└──────────┘      └──────────┘      └──────────┘      └──────────┘
                                                              │
                                                              ▼
┌──────────┐      ┌──────────┐      ┌──────────┐      ┌──────────┐
│Production│◄─────│  Deploy  │◄─────│  Push    │◄─────│  Build   │
│ K8s      │      │  to K8s  │      │  Image   │      │  Docker  │
└──────────┘      └──────────┘      └──────────┘      └──────────┘
```

**GitHub Actions Workflow:**

```yaml
# .github/workflows/ci-cd.yml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  # Job 1: Lint and validate
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Lint Dockerfile
        uses: hadolint/hadolint-action@v3.1.0
        with:
          dockerfile: Dockerfile

      - name: Lint YAML
        run: |
          pip install yamllint
          yamllint k8s/

      - name: Validate Kubernetes manifests
        run: |
          curl -sLO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
          chmod +x kubectl
          ./kubectl apply --dry-run=client -f k8s/

  # Job 2: Build and test
  build:
    needs: lint
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: "20"
          cache: "npm"

      - name: Install dependencies
        run: npm ci

      - name: Run tests
        run: npm test

      - name: Build application
        run: npm run build

      - name: Upload coverage
        uses: codecov/codecov-action@v3

  # Job 3: Security scan
  security:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Run Trivy vulnerability scanner (filesystem)
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: "fs"
          scan-ref: "."
          format: "sarif"
          output: "trivy-results.sarif"

      - name: Upload Trivy results to GitHub Security
        uses: github/codeql-action/upload-sarif@v2
        with:
          sarif_file: "trivy-results.sarif"

      - name: Run Semgrep
        uses: returntocorp/semgrep-action@v1

  # Job 4: Build Docker image
  docker:
    needs: security
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
    outputs:
      image-tag: ${{ steps.meta.outputs.tags }}
    steps:
      - uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Log in to Container Registry
        uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
          tags: |
            type=ref,event=branch
            type=sha,prefix={{branch}}-
            type=semver,pattern={{version}}

      - name: Build and push Docker image
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=gha
          cache-to: type=gha,mode=max

      - name: Scan Docker image
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: ${{ steps.meta.outputs.tags }}
          format: "sarif"
          output: "trivy-image-results.sarif"

      - name: Sign container image
        run: |
          cosign sign --yes ${{ steps.meta.outputs.tags }}

  # Job 5: Deploy to Kubernetes
  deploy:
    needs: docker
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4

      - name: Set up kubectl
        uses: azure/setup-kubectl@v3

      - name: Configure kubectl
        run: |
          mkdir -p $HOME/.kube
          echo "${{ secrets.KUBECONFIG }}" | base64 -d > $HOME/.kube/config

      - name: Update deployment image
        run: |
          kubectl set image deployment/frontend \
            frontend=${{ needs.docker.outputs.image-tag }} \
            -n bootcamp

      - name: Wait for rollout
        run: |
          kubectl rollout status deployment/frontend -n bootcamp
          kubectl rollout status deployment/backend -n bootcamp

      - name: Run smoke tests
        run: |
          kubectl run curl-test --image=curlimages/curl:latest --rm -i --restart=Never -- \
            curl -f http://frontend.bootcamp.svc.cluster.local

  # Job 6: Notify
  notify:
    needs: [lint, build, security, docker, deploy]
    runs-on: ubuntu-latest
    if: always()
    steps:
      - name: Send Slack notification
        uses: slackapi/slack-github-action@v1.24.0
        with:
          webhook-url: ${{ secrets.SLACK_WEBHOOK }}
          payload: |
            {
              "text": "Deployment ${{ job.status }}: ${{ github.repository }}",
              "blocks": [
                {
                  "type": "section",
                  "text": {
                    "type": "mrkdwn",
                    "text": "*Deployment Status:* ${{ job.status }}\n*Repository:* ${{ github.repository }}\n*Branch:* ${{ github.ref_name }}\n*Commit:* ${{ github.sha }}"
                  }
                }
              ]
            }
```

**Tasks:**

1. ✅ Create multi-stage pipeline
2. ✅ Implement linting (Dockerfile, YAML, code)
3. ✅ Add automated tests
4. ✅ Security scanning (Trivy, Semgrep)
5. ✅ Build and push Docker images
6. ✅ Sign container images with Cosign
7. ✅ Deploy to Kubernetes
8. ✅ Run smoke tests
9. ✅ Set up notifications
10. ✅ Test locally with `act`

**Local Testing:**

```bash
# Test workflow locally
act push

# Test specific job
act -j build

# Test with secrets
act -s GITHUB_TOKEN=your-token
```

**Success Criteria:**

- ✅ Pipeline passes all stages
- ✅ No security vulnerabilities
- ✅ Automated deployment works
- ✅ Tests pass
- ✅ Images are signed

#### 📝 Deliverable

Blog post: "Building a Production CI/CD Pipeline with GitHub Actions"

---

### Week 2, Days 3-5: Monitoring & Observability

**Learning Objectives:**

- Set up Prometheus and Grafana
- Implement logging with Loki
- Configure alerting
- Create dashboards

#### 🛠️ Project 1.4: Complete Observability Stack (30 hours - Days 3-5)

**Deploy full monitoring solution**

```bash
cd ~/devops-bootcamp/week4-monitoring
nix flake init -t github:DevLayers/nix-config#monitoring
nix develop
```

**Observability Stack:**

```
┌─────────────────────────────────────────────────────────┐
│                      Grafana                            │
│              (Dashboards & Visualization)               │
└───────┬──────────────────┬──────────────────┬──────────┘
        │                  │                  │
   ┌────▼─────┐      ┌─────▼──────┐    ┌─────▼──────┐
   │Prometheus│      │    Loki    │    │   Jaeger   │
   │ Metrics  │      │    Logs    │    │   Traces   │
   └────┬─────┘      └─────┬──────┘    └─────┬──────┘
        │                  │                  │
   ┌────▼──────────────────▼──────────────────▼──────┐
   │              Your Applications                   │
   │         (with instrumentation)                   │
   └──────────────────────────────────────────────────┘
```

**Deployment Structure:**

```yaml
# k8s/monitoring/prometheus/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prometheus
  namespace: monitoring
spec:
  replicas: 1
  selector:
    matchLabels:
      app: prometheus
  template:
    metadata:
      labels:
        app: prometheus
    spec:
      serviceAccountName: prometheus
      containers:
        - name: prometheus
          image: prom/prometheus:latest
          args:
            - "--config.file=/etc/prometheus/prometheus.yml"
            - "--storage.tsdb.path=/prometheus"
            - "--storage.tsdb.retention.time=7d"
          ports:
            - containerPort: 9090
          volumeMounts:
            - name: config
              mountPath: /etc/prometheus
            - name: storage
              mountPath: /prometheus
          resources:
            requests:
              memory: "512Mi"
              cpu: "500m"
            limits:
              memory: "1Gi"
              cpu: "1000m"
      volumes:
        - name: config
          configMap:
            name: prometheus-config
        - name: storage
          persistentVolumeClaim:
            claimName: prometheus-pvc
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-config
  namespace: monitoring
data:
  prometheus.yml: |
    global:
      scrape_interval: 15s
      evaluation_interval: 15s

    alerting:
      alertmanagers:
      - static_configs:
        - targets:
          - alertmanager:9093

    rule_files:
      - /etc/prometheus/rules/*.yml

    scrape_configs:
      # Kubernetes API server
      - job_name: 'kubernetes-apiservers'
        kubernetes_sd_configs:
        - role: endpoints
        scheme: https
        tls_config:
          ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
        relabel_configs:
        - source_labels: [__meta_kubernetes_namespace, __meta_kubernetes_service_name, __meta_kubernetes_endpoint_port_name]
          action: keep
          regex: default;kubernetes;https

      # Kubernetes nodes
      - job_name: 'kubernetes-nodes'
        kubernetes_sd_configs:
        - role: node
        scheme: https
        tls_config:
          ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
        relabel_configs:
        - action: labelmap
          regex: __meta_kubernetes_node_label_(.+)

      # Kubernetes pods
      - job_name: 'kubernetes-pods'
        kubernetes_sd_configs:
        - role: pod
        relabel_configs:
        - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
          action: keep
          regex: true
        - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
          action: replace
          target_label: __metrics_path__
          regex: (.+)
        - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
          action: replace
          regex: ([^:]+)(?::\d+)?;(\d+)
          replacement: $1:$2
          target_label: __address__
        - action: labelmap
          regex: __meta_kubernetes_pod_label_(.+)
        - source_labels: [__meta_kubernetes_namespace]
          action: replace
          target_label: kubernetes_namespace
        - source_labels: [__meta_kubernetes_pod_name]
          action: replace
          target_label: kubernetes_pod_name
```

**Grafana Dashboard Configuration:**

```yaml
# k8s/monitoring/grafana/configmap-dashboards.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: grafana-dashboards
  namespace: monitoring
data:
  kubernetes-cluster.json: |
    {
      "dashboard": {
        "title": "Kubernetes Cluster Overview",
        "panels": [
          {
            "title": "CPU Usage",
            "targets": [
              {
                "expr": "sum(rate(container_cpu_usage_seconds_total[5m])) by (pod)"
              }
            ]
          },
          {
            "title": "Memory Usage",
            "targets": [
              {
                "expr": "sum(container_memory_working_set_bytes) by (pod)"
              }
            ]
          },
          {
            "title": "Network I/O",
            "targets": [
              {
                "expr": "sum(rate(container_network_receive_bytes_total[5m])) by (pod)"
              }
            ]
          }
        ]
      }
    }
```

**Alert Rules:**

```yaml
# k8s/monitoring/prometheus/alerts.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-rules
  namespace: monitoring
data:
  alerts.yml: |
    groups:
    - name: kubernetes
      interval: 30s
      rules:
      # Pod alerts
      - alert: PodCrashLooping
        expr: rate(kube_pod_container_status_restarts_total[15m]) > 0
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "Pod {{ $labels.pod }} is crash looping"
          description: "Pod {{ $labels.namespace }}/{{ $labels.pod }} has restarted {{ $value }} times in the last 15 minutes."

      - alert: PodNotReady
        expr: kube_pod_status_phase{phase!="Running"} == 1
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "Pod {{ $labels.pod }} not ready"
          description: "Pod {{ $labels.namespace }}/{{ $labels.pod }} has been in a non-ready state for more than 10 minutes."

      # Node alerts
      - alert: NodeMemoryPressure
        expr: kube_node_status_condition{condition="MemoryPressure",status="true"} == 1
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Node {{ $labels.node }} under memory pressure"
          description: "Node {{ $labels.node }} is under memory pressure."

      - alert: NodeDiskPressure
        expr: kube_node_status_condition{condition="DiskPressure",status="true"} == 1
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Node {{ $labels.node }} under disk pressure"
          description: "Node {{ $labels.node }} is under disk pressure."

      # Application alerts
      - alert: HighErrorRate
        expr: rate(http_requests_total{status=~"5.."}[5m]) > 0.05
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "High error rate on {{ $labels.service }}"
          description: "Service {{ $labels.service }} has an error rate of {{ $value }} (> 5%)."

      - alert: HighLatency
        expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 1
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "High latency on {{ $labels.service }}"
          description: "Service {{ $labels.service }} has 95th percentile latency of {{ $value }}s (> 1s)."
```

**Tasks:**

1. ✅ Deploy Prometheus with persistent storage
2. ✅ Deploy Grafana with datasources
3. ✅ Deploy Loki for log aggregation
4. ✅ Deploy Jaeger for distributed tracing
5. ✅ Configure service discovery
6. ✅ Create custom Grafana dashboards
7. ✅ Set up alert rules
8. ✅ Configure AlertManager
9. ✅ Instrument your applications
10. ✅ Set up log shipping from apps

**Validation:**

```bash
# Deploy monitoring stack
kubectl create namespace monitoring
kubectl apply -f k8s/monitoring/

# Check pods
kubectl get pods -n monitoring

# Port forward Grafana
kubectl port-forward -n monitoring svc/grafana 3000:3000

# Access Grafana: http://localhost:3000
# Default credentials: admin/admin

# Port forward Prometheus
kubectl port-forward -n monitoring svc/prometheus 9090:9090

# Test alert
kubectl delete pod <some-pod> -n bootcamp
# Watch alert fire in AlertManager

# Query metrics
curl http://localhost:9090/api/v1/query?query=up

# Check logs in Loki
kubectl port-forward -n monitoring svc/loki 3100:3100
logcli query '{namespace="bootcamp"}'
```

**Success Criteria:**

- ✅ All monitoring components running
- ✅ Metrics collecting from all pods
- ✅ Dashboards showing real data
- ✅ Alerts firing correctly
- ✅ Logs aggregated and queryable

#### 📝 Deliverable

Blog post: "Building a Production Observability Stack for Kubernetes"

---

## 🎯 Weeks 1-2 Summary & Portfolio Review

### What You've Built (Weeks 1-2):

```
✅ Project 1.1: AWS VPC Infrastructure (Terraform)
✅ Project 1.2: Full-Stack App on Kubernetes
✅ Project 1.3: Complete CI/CD Pipeline
✅ Project 1.4: Observability Stack

Total: 4 Production Projects (104 hours)
Blog Posts: 4
Skills: IaC, Kubernetes, CI/CD, Monitoring
Time Invested: 2 weeks intensive
```

### Portfolio Checklist:

```bash
# GitHub repositories should show:
✅ devops-bootcamp-vpc/
   ├── Terraform modules
   ├── Security scans passing
   ├── Documentation
   └── README with architecture

✅ devops-bootcamp-k8s-app/
   ├── Multi-tier application
   ├── Kubernetes manifests
   ├── Dockerfiles
   └── README with deployment guide

✅ devops-bootcamp-cicd/
   ├── GitHub Actions workflows
   ├── Security scanning
   ├── Automated deployment
   └── README with pipeline diagram

✅ devops-bootcamp-monitoring/
   ├── Prometheus configuration
   ├── Grafana dashboards
   ├── Alert rules
   └── README with screenshots
```

### Month 1 Assessment:

**Skills Acquired:**

- ✅ Terraform fundamentals
- ✅ Kubernetes deployment
- ✅ CI/CD automation
- ✅ Monitoring & alerting

**Next Month Goals:**

- GitOps workflows
- Advanced Kubernetes
- Security hardening
- Cost optimization

---

## 🚀 Week 3: Cloud & Advanced Kubernetes

### Week 3, Days 1-3: Multi-Region AWS Infrastructure

#### 🛠️ Project 2.1: Multi-Region AWS Deployment (36 hours - Days 1-3)

**Deploy application across multiple AWS regions for high availability**

```bash
cd ~/devops-bootcamp/week3-multiregion-aws
nix flake init -t github:DevLayers/nix-config#cloud
nix develop
```

**Project Structure:**

```
month2-week1-multiregion/
├── terraform/
│   ├── us-east-1/
│   │   ├── main.tf           # Primary EKS cluster
│   │   ├── vpc.tf
│   │   └── outputs.tf
│   ├── us-west-2/
│   │   ├── main.tf           # Secondary EKS cluster
│   │   ├── vpc.tf
│   │   └── outputs.tf
│   ├── eu-west-1/
│   │   ├── main.tf           # EU EKS cluster
│   │   ├── vpc.tf
│   │   └── outputs.tf
│   └── modules/
│       ├── eks-cluster/
│       └── global-routing/
├── k8s/
│   └── base/                 # Kustomize base
└── README.md
```

**Tasks:**

1. ✅ Create EKS clusters in 3 AWS regions (us-east-1, us-west-2, eu-west-1)
2. ✅ Use Terraform modules/workspaces to manage regional differences
3. ✅ Deploy the same application to all regions
4. ✅ Implement cost monitoring per region
5. ✅ Set up cross-region networking (VPC peering / Transit Gateway)
6. ✅ Configure DNS with Route53 geo-routing and failover
7. ✅ Implement regional disaster recovery scenarios
8. ✅ Perform latency and cost comparison analysis between regions

**Success Criteria:**

- ✅ App running in all 3 AWS regions
- ✅ Infrastructure as code
- ✅ Cost under $50/month across regions
- ✅ Documented regional comparison

#### 📝 Deliverable

Blog: "Multi-Region Kubernetes on AWS: us-east-1 vs us-west-2 vs eu-west-1"

---

### Week 3, Days 4-5: GitOps with ArgoCD

#### 🛠️ Project 2.2: GitOps Workflow (24 hours - Days 4-5)

**Implement complete GitOps deployment**

```bash
cd ~/devops-bootcamp/month2-week2-gitops
nix flake init -t github:DevLayers/nix-config#gitops
nix develop
```

**GitOps Repository Structure:**

```
gitops-config/
├── apps/
│   ├── frontend/
│   │   ├── base/
│   │   └── overlays/
│   │       ├── dev/
│   │       ├── staging/
│   │       └── production/
│   └── backend/
├── infrastructure/
│   ├── monitoring/
│   ├── ingress/
│   └── cert-manager/
└── argocd/
    └── applications/
```

**ArgoCD Application:**

```yaml
# argocd/applications/frontend-prod.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: frontend-production
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/yourusername/gitops-config
    targetRevision: HEAD
    path: apps/frontend/overlays/production
  destination:
    server: https://kubernetes.default.svc
    namespace: production
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
      allowEmpty: false
    syncOptions:
      - CreateNamespace=true
    retry:
      limit: 5
      backoff:
        duration: 5s
        factor: 2
        maxDuration: 3m
```

**Tasks:**

1. ✅ Install ArgoCD
2. ✅ Create GitOps repository structure
3. ✅ Configure Kustomize overlays
4. ✅ Set up automated sync
5. ✅ Implement secrets with Sealed Secrets
6. ✅ Configure RBAC
7. ✅ Set up notifications (Slack)
8. ✅ Implement rollback strategy
9. ✅ Create app-of-apps pattern
10. ✅ Configure image updater

**Success Criteria:**

- ✅ Auto-deployment from Git
- ✅ Secrets encrypted
- ✅ Rollback tested
- ✅ Notifications working

#### 📝 Deliverable

Blog: "Production GitOps with ArgoCD and Kustomize"

---

### Week 3, Days 6-7: Security & Compliance

#### 🛠️ Project 2.3: Security Hardening (24 hours - Days 6-7)

**Implement comprehensive security**

```bash
cd ~/devops-bootcamp/month2-week3-security
nix flake init -t github:DevLayers/nix-config#secops
nix develop
```

**Security Components:**

```
Security Stack:
├── Container Security
│   ├── Trivy scanning
│   ├── Image signing (Cosign)
│   └── Registry security
├── Kubernetes Security
│   ├── Pod Security Standards
│   ├── Network Policies
│   ├── RBAC
│   └── Security contexts
├── Secrets Management
│   ├── HashiCorp Vault
│   ├── Sealed Secrets
│   └── External Secrets Operator
└── Compliance
    ├── OPA policies
    ├── Kubescape scans
    └── Audit logging
```

**Network Policy Example:**

```yaml
# k8s/security/network-policy.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: frontend-network-policy
  namespace: production
spec:
  podSelector:
    matchLabels:
      app: frontend
  policyTypes:
    - Ingress
    - Egress
  ingress:
    # Allow from ingress controller
    - from:
        - namespaceSelector:
            matchLabels:
              name: ingress-nginx
      ports:
        - protocol: TCP
          port: 80
  egress:
    # Allow to backend
    - to:
        - podSelector:
            matchLabels:
              app: backend
      ports:
        - protocol: TCP
          port: 8080
    # Allow DNS
    - to:
        - namespaceSelector:
            matchLabels:
              name: kube-system
        - podSelector:
            matchLabels:
              k8s-app: kube-dns
      ports:
        - protocol: UDP
          port: 53
```

**OPA Policy:**

```rego
# policies/required-labels.rego
package kubernetes.admission

deny[msg] {
  input.request.kind.kind == "Deployment"
  not input.request.object.metadata.labels.app
  msg = "Deployment must have 'app' label"
}

deny[msg] {
  input.request.kind.kind == "Deployment"
  not input.request.object.metadata.labels.environment
  msg = "Deployment must have 'environment' label"
}

deny[msg] {
  input.request.kind.kind == "Deployment"
  container := input.request.object.spec.template.spec.containers[_]
  not container.securityContext.runAsNonRoot
  msg = sprintf("Container %v must run as non-root user", [container.name])
}

deny[msg] {
  input.request.kind.kind == "Deployment"
  container := input.request.object.spec.template.spec.containers[_]
  not container.resources.limits
  msg = sprintf("Container %v must have resource limits", [container.name])
}
```

**Tasks:**

1. ✅ Implement Pod Security Standards
2. ✅ Create Network Policies
3. ✅ Set up HashiCorp Vault
4. ✅ Configure OPA Gatekeeper
5. ✅ Implement image scanning
6. ✅ Set up SIEM logging
7. ✅ Create security dashboards
8. ✅ Conduct security audit
9. ✅ Document security procedures
10. ✅ Pass compliance scan

**Success Criteria:**

- ✅ Kubescape score > 80
- ✅ No critical vulnerabilities
- ✅ Network policies enforced
- ✅ Secrets encrypted
- ✅ Audit logs enabled

#### 📝 Deliverable

Blog: "Kubernetes Security Best Practices: From Zero to Production"

---

### Week 4, Days 1-3: SRE & Chaos Engineering

#### 🛠️ Project 2.4: SRE Practices (36 hours - Days 1-3)

**Implement SRE fundamentals**

```bash
cd ~/devops-bootcamp/month2-week4-sre
nix flake init -t github:DevLayers/nix-config#sre
nix develop
```

**SRE Components:**

```
SRE Implementation:
├── SLI/SLO/SLA Definition
├── Error Budget Tracking
├── Incident Response
│   ├── Runbooks
│   ├── On-call rotation
│   └── Post-mortems
├── Chaos Engineering
│   ├── Pod deletion
│   ├── Network latency
│   └── Resource exhaustion
├── Disaster Recovery
│   ├── Backups (Velero)
│   ├── Restore procedures
│   └── DR testing
└── Performance Testing
    ├── Load tests (K6)
    ├── Stress tests
    └── Capacity planning
```

**SLO Definition:**

```yaml
# slo/frontend-slo.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: frontend-slo
  namespace: production
data:
  slo.yaml: |
    slos:
    - name: frontend-availability
      description: Frontend service availability
      target: 99.9  # 99.9% uptime
      indicator:
        type: availability
        query: |
          sum(rate(http_requests_total{job="frontend",status!~"5.."}[5m]))
          /
          sum(rate(http_requests_total{job="frontend"}[5m]))
      window: 30d

    - name: frontend-latency
      description: Frontend p95 latency under 500ms
      target: 95  # 95% of requests under 500ms
      indicator:
        type: latency
        query: |
          histogram_quantile(0.95,
            rate(http_request_duration_seconds_bucket{job="frontend"}[5m])
          ) < 0.5
      window: 30d

    - name: frontend-error-rate
      description: Frontend error rate under 1%
      target: 99  # Less than 1% errors
      indicator:
        type: error_rate
        query: |
          1 - (
            sum(rate(http_requests_total{job="frontend",status=~"5.."}[5m]))
            /
            sum(rate(http_requests_total{job="frontend"}[5m]))
          )
      window: 7d
```

**Chaos Engineering Experiment:**

```yaml
# chaos/pod-deletion.yaml
apiVersion: litmuschaos.io/v1alpha1
kind: ChaosEngine
metadata:
  name: frontend-chaos
  namespace: production
spec:
  appinfo:
    appns: production
    applabel: "app=frontend"
    appkind: deployment
  chaosServiceAccount: pod-delete-sa
  experiments:
    - name: pod-delete
      spec:
        components:
          env:
            - name: TOTAL_CHAOS_DURATION
              value: "60"
            - name: CHAOS_INTERVAL
              value: "10"
            - name: FORCE
              value: "false"
```

**Runbook Template:**

````markdown
# Runbook: Frontend Service Down

## Severity: P1 (Critical)

## Symptoms

- Frontend pods not responding
- Health checks failing
- Users reporting 503 errors

## Impact

- Users cannot access the application
- SLO breach if > 43 minutes downtime/month

## Diagnosis Steps

### 1. Check Pod Status

```bash
kubectl get pods -n production -l app=frontend
kubectl describe pod <pod-name> -n production
```
````

### 2. Check Logs

```bash
stern -n production frontend --since 15m
```

### 3. Check Recent Deployments

```bash
kubectl rollout history deployment/frontend -n production
argocd app get frontend-production
```

### 4. Check Dependencies

```bash
# Check backend API
curl -v http://backend.production.svc.cluster.local:8080/health

# Check database
kubectl exec -it postgresql-0 -n production -- psql -U postgres -c "SELECT 1"
```

## Resolution Steps

### Option 1: Rollback

```bash
kubectl rollout undo deployment/frontend -n production
kubectl rollout status deployment/frontend -n production
```

### Option 2: Scale Up

```bash
kubectl scale deployment/frontend --replicas=5 -n production
```

### Option 3: Restart Pods

```bash
kubectl rollout restart deployment/frontend -n production
```

## Prevention

- Add pre-deployment smoke tests
- Implement blue-green deployment
- Improve health check configuration

## Post-Incident

- [ ] Write post-mortem within 24 hours
- [ ] Update runbook with learnings
- [ ] Create action items for prevention
- [ ] Update SLO dashboard

````

**Tasks:**
1. ✅ Define SLIs and SLOs
2. ✅ Create error budget dashboard
3. ✅ Write 5 runbooks
4. ✅ Implement backup with Velero
5. ✅ Run chaos experiments
6. ✅ Conduct DR drill
7. ✅ Perform load testing
8. ✅ Write 2 post-mortems
9. ✅ Set up on-call rotation
10. ✅ Document incident process

**Load Test Example:**

```javascript
// load-test/scenario.js
import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate } from 'k6/metrics';

const failureRate = new Rate('failed_requests');

export const options = {
  stages: [
    { duration: '2m', target: 100 },  // Ramp up to 100 users
    { duration: '5m', target: 100 },  // Stay at 100 users
    { duration: '2m', target: 200 },  // Ramp up to 200 users
    { duration: '5m', target: 200 },  // Stay at 200 users
    { duration: '2m', target: 0 },    // Ramp down to 0 users
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'],  // 95% of requests under 500ms
    failed_requests: ['rate<0.01'],    // Error rate under 1%
  },
};

export default function () {
  const response = http.get('http://app.bootcamp.local');

  check(response, {
    'status is 200': (r) => r.status === 200,
    'response time < 500ms': (r) => r.timings.duration < 500,
  });

  failureRate.add(response.status !== 200);

  sleep(1);
}
````

**Success Criteria:**

- ✅ SLOs defined and tracked
- ✅ Runbooks complete
- ✅ Chaos tests pass
- ✅ DR drill successful
- ✅ Load test passes

#### 📝 Deliverable

Blog: "SRE in Practice: SLOs, Chaos Engineering, and Incident Response"

---

## 🎯 Weeks 3-4 Summary

### Projects Completed:

```
✅ Project 2.1: Multi-Region AWS Infrastructure
✅ Project 2.2: GitOps with ArgoCD
✅ Project 2.3: Security Hardening
✅ Project 2.4: SRE Practices

Weeks 3-4 Total: 4 Projects (120 hours)
Cumulative: 8 Projects (224 hours)
Blog Posts: 8
```

### Skills Matrix (After Week 4):

```
Infrastructure as Code:       ████████████████░░░░ 80%
Kubernetes:                   ████████████████░░░░ 80%
CI/CD:                        ███████████████░░░░░ 75%
Monitoring:                   ███████████████░░░░░ 75%
Security:                     ██████████████░░░░░░ 70%
GitOps:                       ██████████████░░░░░░ 70%
SRE:                          ████████████░░░░░░░░ 60%
AWS Multi-Region:             ████████████░░░░░░░░ 60%

OVERALL:                      ██████████████░░░░░░ 71%
```

**You're now a solid Junior DevOps Engineer!** 🎉

---

## 🚀 Phase 2: Production Skills (Weeks 4-5)

### Week 4, Days 4-7: Platform Engineering

#### 🛠️ Project 3.1: Internal Developer Platform (48 hours - Days 4-7)

**Build self-service infrastructure platform**

```bash
cd ~/devops-bootcamp/month3-week1-platform
nix flake init -t github:DevLayers/nix-config#platform-engineering
nix develop
```

**Platform Components:**

```
Developer Platform:
├── Service Catalog
│   ├── API service template
│   ├── Database template
│   ├── Cache template
│   └── Job template
├── Infrastructure as Code Library
│   ├── Terraform modules
│   ├── Helm charts
│   └── Kustomize bases
├── CI/CD Templates
│   ├── GitHub Actions workflows
│   ├── Security scans
│   └── Deployment strategies
├── Observability
│   ├── Auto-instrumentation
│   ├── Log aggregation
│   └── Dashboards
└── Developer Portal
    ├── Service catalog UI
    ├── Documentation
    └── Getting started guides
```

**Service Template (Cookiecutter):**

```yaml
# cookiecutter.json
{
  "service_name": "my-service",
  "service_type": ["api", "worker", "cronjob"],
  "language": ["go", "nodejs", "python"],
  "database": ["postgresql", "mysql", "mongodb", "none"],
  "cache": ["redis", "memcached", "none"],
  "message_queue": ["rabbitmq", "kafka", "none"],
  "team_name": "platform",
  "author_name": "Your Name",
}
```

**Generated Project Structure:**

```
{{ cookiecutter.service_name }}/
├── src/                        # Application code
├── Dockerfile                  # Multi-stage build
├── k8s/
│   ├── base/
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   ├── hpa.yaml
│   │   └── servicemonitor.yaml
│   └── overlays/
│       ├── dev/
│       ├── staging/
│       └── production/
├── .github/
│   └── workflows/
│       ├── ci.yml
│       ├── cd.yml
│       └── security.yml
├── terraform/
│   └── {{ cookiecutter.database }}/
├── docs/
│   ├── README.md
│   ├── RUNBOOK.md
│   └── API.md
└── Makefile
```

**Crossplane Composition:**

```yaml
# platform/compositions/postgres-db.yaml
apiVersion: apiextensions.crossplane.io/v1
kind: Composition
metadata:
  name: postgres-db
spec:
  compositeTypeRef:
    apiVersion: platform.example.com/v1alpha1
    kind: PostgresDatabase
  resources:
    - name: rds-instance
      base:
        apiVersion: rds.aws.crossplane.io/v1beta1
        kind: DBInstance
        spec:
          forProvider:
            region: us-east-1
            dbInstanceClass: db.t3.micro
            engine: postgres
            engineVersion: "14"
            allocatedStorage: 20
            storageEncrypted: true
            publiclyAccessible: false
            backupRetentionPeriod: 7
            deletionProtection: false
      patches:
        - fromFieldPath: "spec.parameters.size"
          toFieldPath: "spec.forProvider.dbInstanceClass"
          transforms:
            - type: map
              map:
                small: db.t3.micro
                medium: db.t3.small
                large: db.t3.medium
```

**Platform API (Custom Resource):**

```yaml
# Request a database
apiVersion: platform.example.com/v1alpha1
kind: PostgresDatabase
metadata:
  name: myapp-db
  namespace: dev
spec:
  parameters:
    size: small
    backupRetention: 7
  writeConnectionSecretToRef:
    name: myapp-db-credentials
    namespace: dev
```

**Tasks:**

1. ✅ Create service templates with Cookiecutter
2. ✅ Build Terraform module library
3. ✅ Implement Crossplane compositions
4. ✅ Set up self-service database provisioning
5. ✅ Create CI/CD templates
6. ✅ Build developer portal (Backstage)
7. ✅ Write platform documentation
8. ✅ Implement RBAC for self-service
9. ✅ Create cost tracking
10. ✅ Conduct platform training

**Success Criteria:**

- ✅ Developers can self-serve infrastructure
- ✅ Service creation takes < 15 minutes
- ✅ All services follow standards
- ✅ Cost visibility per team

#### 📝 Deliverable

Blog: "Building an Internal Developer Platform with Kubernetes and Crossplane"

---

### Week 5: Real-World Projects

**Focus**: Build production-grade projects for portfolio

#### 🛠️ Project 3.2: E-Commerce Platform (60 hours - Week 5)

**Complete production system**

```
E-Commerce Platform:
├── Frontend (React/Next.js)
├── API Gateway (Kong/Envoy)
├── Product Service (Go)
├── Order Service (Node.js)
├── Payment Service (Python)
├── User Service (Java)
├── Notification Service (Go)
├── Search Service (Elasticsearch)
├── Databases (PostgreSQL, MongoDB, Redis)
├── Message Queue (RabbitMQ)
└── Full Observability Stack
```

**Features:**

- ✅ Microservices architecture
- ✅ Service mesh (Istio)
- ✅ Event-driven design
- ✅ CQRS pattern
- ✅ Full CI/CD
- ✅ Auto-scaling
- ✅ Disaster recovery
- ✅ Security hardening

#### 🛠️ Project 3.3: Open Source Contribution (20 hours - Week 5 evenings)

**Contribute to CNCF projects** (parallel with Project 3.2)

**Targets:**

1. ✅ Kubernetes documentation
2. ✅ ArgoCD bug fix
3. ✅ Prometheus exporter
4. ✅ Helm chart improvement

#### 🛠️ Project 3.4: Technical Blog (Ongoing)

**Write 10 more articles (10 hours total - 1 hour/day throughout bootcamp)**

**Topics:**

1. ✅ "Kubernetes Networking Deep Dive"
2. ✅ "GitOps Best Practices"
3. ✅ "Cost Optimization in Kubernetes"
4. ✅ "Debugging Production Issues"
5. ✅ "Service Mesh Comparison"
6. ✅ "Secrets Management Strategies"
7. ✅ "Disaster Recovery Testing"
8. ✅ "Platform Engineering Patterns"
9. ✅ "Multi-Tenancy in Kubernetes"
10. ✅ "DevOps Metrics That Matter"

---

## 🎯 Phase 3: Advanced & Portfolio (Weeks 6-8)

### Weeks 6-8: Portfolio Projects & Job Preparation

#### 🛠️ Final Projects

**Project F.1: Personal Infrastructure (36 hours - Week 6)**

- ✅ Home lab Kubernetes cluster
- ✅ Self-hosted services (Nextcloud, Gitea, etc.)
- ✅ Automated backups
- ✅ Monitoring and alerting
- ✅ Public-facing portfolio site

**Project F.2: Infrastructure Showcase (25 hours)**

- ✅ Multi-region deployment
- ✅ Global load balancing
- ✅ Disaster recovery tested
- ✅ Cost under $100/month
- ✅ Open source all code

**Project F.3: Technical Certification (40 hours)**

- ✅ CKA (Certified Kubernetes Administrator)
- ✅ Terraform Associate
- ✅ AWS Solutions Architect Associate

---

## 💼 Career Preparation

### Resume Template

```markdown
# YOUR NAME

DevOps Engineer | Kubernetes | Terraform | AWS

[Email] | [LinkedIn] | [GitHub] | [Portfolio]

## Summary

DevOps Engineer with production experience deploying and managing
cloud-native applications. Proficient in Kubernetes, Terraform,
CI/CD, and observability. Built 15+ production projects with focus
on automation, security, and reliability.

## Technical Skills

- **Container Orchestration**: Kubernetes, Docker, Helm, Kustomize
- **Infrastructure as Code**: Terraform, Ansible, Crossplane
- **Cloud Platforms**: AWS (EKS, EC2, RDS, S3, Lambda, CloudFormation, Route53, VPC)
- **CI/CD**: GitHub Actions, GitLab CI, ArgoCD, FluxCD
- **Monitoring**: Prometheus, Grafana, Loki, Jaeger, OpenTelemetry
- **Security**: Trivy, Vault, OPA, Network Policies, Pod Security
- **Programming**: Go, Python, Bash, YAML, HCL
- **Service Mesh**: Istio, Linkerd

## Projects

### E-Commerce Microservices Platform

_Production-grade distributed system_

- Deployed 7-service microservices architecture to Kubernetes
- Implemented GitOps with ArgoCD for 3 environments (dev/staging/prod)
- Configured Istio service mesh with mTLS and circuit breakers
- Built CI/CD pipeline with security scanning (Trivy, Semgrep)
- Achieved 99.9% uptime with auto-scaling and monitoring
- Tech: Kubernetes, Istio, ArgoCD, Prometheus, Grafana, Terraform
- **[GitHub](link)** | **[Demo](link)** | **[Blog Post](link)**

### Multi-Region AWS Infrastructure

_High-availability infrastructure across multiple AWS regions_

- Deployed EKS clusters across 3 AWS regions (us-east-1, us-west-2, eu-west-1)
- Created reusable Terraform modules for consistent multi-region deployments
- Implemented disaster recovery with automated regional failover using Route53
- Reduced costs by 40% through resource optimization and right-sizing
- Tech: Terraform, AWS (EKS, VPC, Route53, CloudWatch), Kubernetes, Kustomize
- **[GitHub](link)** | **[Documentation](link)**

### Internal Developer Platform

_Self-service infrastructure for development teams_

- Built platform using Crossplane for infrastructure provisioning
- Created service catalog with 10+ templates (Cookiecutter)
- Implemented RBAC for multi-tenancy
- Reduced service deployment time from 2 hours to 15 minutes
- Tech: Kubernetes, Crossplane, Backstage, Terraform, ArgoCD
- **[GitHub](link)** | **[Blog Post](link)**

### Production Observability Stack

_Complete monitoring and alerting solution_

- Deployed Prometheus, Grafana, Loki, and Jaeger on Kubernetes
- Created 20+ custom Grafana dashboards
- Configured 50+ alerting rules with AlertManager
- Implemented distributed tracing for microservices
- Reduced MTTR from 2 hours to 15 minutes
- Tech: Prometheus, Grafana, Loki, Jaeger, AlertManager
- **[GitHub](link)** | **[Dashboards](link)**

## Open Source Contributions

- **Kubernetes** - Documentation improvements (#12345)
- **ArgoCD** - Bug fix for sync logic (#67890)
- **Prometheus** - Custom exporter for application metrics
- **Helm Charts** - Community chart improvements

## Certifications

- Certified Kubernetes Administrator (CKA) - 2026
- HashiCorp Certified: Terraform Associate - 2026
- AWS Certified Solutions Architect - Associate - 2026

## Technical Writing

- **Blog**: 20+ articles on DevOps topics ([blog.example.com](link))
- **Topics**: Kubernetes, GitOps, Security, Monitoring, Platform Engineering
- **Views**: 10,000+ monthly readers

## Experience

### Personal Projects & Bootcamp

_DevOps Engineer (Self-Taught)_ | 2026

- Completed intensive 8-week DevOps bootcamp (700+ hours)
- Built 15+ production-grade projects
- Contributed to 3 CNCF open-source projects
- Maintained personal infrastructure (99.95% uptime)
- Published 20+ technical blog posts

## Education

[Your Education]
```

### LinkedIn Profile Optimization

```markdown
Headline:
DevOps Engineer | Kubernetes | Terraform | AWS | Building Reliable Cloud Infrastructure

About:
Passionate DevOps Engineer specializing in Kubernetes, Infrastructure
as Code, and Cloud-Native technologies. I build reliable, scalable,
and secure infrastructure that empowers development teams.

🚀 What I Do:
• Deploy and manage production Kubernetes clusters
• Automate infrastructure with Terraform and Ansible
• Build CI/CD pipelines with GitOps practices
• Implement comprehensive observability stacks
• Design self-service developer platforms

💡 Recent Projects:
• E-commerce microservices platform (7 services, 99.9% uptime)
• Multi-region AWS infrastructure (3 regions, HA)
• Internal developer platform (15min service deployment)
• Production monitoring with Prometheus & Grafana

🛠️ Tech Stack:
Kubernetes | Docker | Terraform | AWS (EKS, EC2, RDS, Lambda) | ArgoCD
Prometheus | Grafana | Istio | GitHub Actions | Python | Go | Bash

📝 Technical Writer:
I share DevOps knowledge through my blog with 20+ articles covering:
Kubernetes, GitOps, Security, Monitoring, Platform Engineering
[Link to blog]

🎯 Currently:
• Building production infrastructure
• Contributing to CNCF projects
• Sharing DevOps best practices
• Pursuing CKA certification

📫 Let's connect if you're interested in:
• DevOps best practices
• Kubernetes and cloud-native tech
• Platform engineering
• Infrastructure automation

[Link to GitHub] | [Link to Portfolio] | [Link to Blog]
```

### Interview Preparation

#### Technical Questions Practice:

**Kubernetes:**

```
Q: Explain the difference between Deployment, StatefulSet, and DaemonSet.
A: [Your detailed answer with examples from your projects]

Q: How do you troubleshoot a pod that's CrashLoopBackOff?
A: [Step-by-step debugging process you've used]

Q: Explain Kubernetes networking.
A: [CNI, Services, Ingress, Network Policies with examples]
```

**Terraform:**

```
Q: What is Terraform state and why is it important?
A: [Explanation with remote backend examples]

Q: How do you handle secrets in Terraform?
A: [SOPS, Vault, environment variables, examples]
```

**CI/CD:**

```
Q: Design a CI/CD pipeline for a microservices application.
A: [Draw architecture, explain stages, security, rollback]
```

#### Behavioral Questions:

```
Q: Tell me about a time you debugged a production issue.
A: Use STAR method (Situation, Task, Action, Result)
   Example: "When my e-commerce project had high latency..."

Q: How do you handle on-call incidents?
A: Reference your runbooks and incident response process
```

---

## 📊 Daily Routine (Intensive - 12-13 hours/day)

### Daily Schedule (Every Day):

```
6:00 AM - 6:30 AM    Wake up, coffee, review daily goals
6:30 AM - 8:00 AM    Theory/Learning (read docs, watch tutorials)
8:00 AM - 12:00 PM   Hands-on project work (deep focus)
12:00 PM - 1:00 PM   Lunch break + light exercise
1:00 PM - 5:00 PM    Continue project work (implementation)
5:00 PM - 6:00 PM    Testing, debugging, validation
6:00 PM - 7:00 PM    Dinner break
7:00 PM - 9:00 PM    Documentation, blog writing, or advanced topics
9:00 PM - 10:00 PM   Review progress, commit code, plan tomorrow
10:00 PM - 11:00 PM  Optional: Reading, community engagement, or rest

Total: 12-13 productive hours
Breaks: 2 hours
Sleep: 7 hours minimum (CRITICAL for retention!)
```

### Weekly Pattern:

```
Days 1-5:   Primary project execution (12-13 hrs/day)
Day 6:      Review week, catch up, open source (10-12 hrs)
Day 7:      Lighter day - blog writing, study, planning (8-10 hrs)

Note: This is INTENSIVE. Take short breaks every 90 minutes!
```

---

## 📈 Progress Tracking

### Weekly Checklist:

```markdown
## Week X - [Date]

### Learning Goals

- [ ] Complete [specific tutorial/course]
- [ ] Read [specific documentation]
- [ ] Watch [specific video]

### Project Goals

- [ ] Implement [specific feature]
- [ ] Deploy [specific component]
- [ ] Test [specific scenario]
- [ ] Document [specific topic]

### Achievements

- [ ] Project deployed successfully
- [ ] Blog post published
- [ ] Issue resolved
- [ ] Certification progress

### Challenges & Learnings

- Challenge: [What went wrong]
- Solution: [How you fixed it]
- Learning: [What you learned]

### Next Week

- [ ] Priority 1
- [ ] Priority 2
- [ ] Priority 3
```

### Monthly Review:

```markdown
## Month X Review

### Projects Completed

1. Project Name - [Link] - [Status]
2. Project Name - [Link] - [Status]

### Skills Improved

- Skill 1: Before X% → After Y%
- Skill 2: Before X% → After Y%

### Blog Posts

1. [Title] - [Link] - [Views]
2. [Title] - [Link] - [Views]

### Open Source

- Contribution 1 - [PR Link]
- Contribution 2 - [PR Link]

### Certifications

- [Progress on certification]

### GitHub Stats

- Commits: X
- Pull Requests: X
- Issues: X
- Stars Received: X

### Networking

- LinkedIn Connections: +X
- Technical Discussions: X
- Meetups Attended: X

### Next Week Goals

1. Complete [specific project]
2. Achieve [specific milestone]
3. Learn [specific skill]

### Reflections

## What went well:

## What needs improvement:

## Key learnings:
```

---

## 🎯 Success Metrics

### After 8 Weeks, You Should Have:

#### Portfolio

```
✅ 15+ production-grade projects on GitHub
✅ Personal infrastructure running 24/7
✅ 3+ open source contributions
✅ Technical blog with 20+ posts
✅ Professional website/portfolio
```

#### Skills

```
✅ Deploy production Kubernetes clusters
✅ Write production-grade Terraform
✅ Build complete CI/CD pipelines
✅ Implement comprehensive monitoring
✅ Handle security and compliance
✅ Debug distributed systems
✅ Respond to production incidents
```

#### Certifications

```
✅ CKA (Certified Kubernetes Administrator)
✅ HashiCorp Terraform Associate
✅ AWS Solutions Architect Associate
```

#### Career Readiness

```
✅ Strong GitHub profile
✅ Professional LinkedIn
✅ Technical blog audience
✅ Interview-ready stories
✅ Network of DevOps professionals
✅ Reference projects to discuss
```

---

## 🎓 Final Assessment

### Self-Assessment Rubric:

```
Rate yourself 1-10 on each:

Technical Skills:
[ ] Kubernetes deployment & management
[ ] Infrastructure as Code (Terraform)
[ ] CI/CD pipeline creation
[ ] Monitoring & observability
[ ] Security & compliance
[ ] Cloud platforms (AWS - multiple services)
[ ] GitOps practices
[ ] Troubleshooting & debugging

Soft Skills:
[ ] Documentation writing
[ ] Technical communication
[ ] Problem-solving
[ ] Time management
[ ] Learning agility
[ ] Collaboration
[ ] Incident response
[ ] Teaching/mentoring

Portfolio Quality:
[ ] Code quality
[ ] Project documentation
[ ] README files
[ ] Architecture diagrams
[ ] Blog post quality
[ ] GitHub activity
[ ] Open source contributions
[ ] Professional presence

Job Readiness:
[ ] Resume quality
[ ] LinkedIn profile
[ ] Portfolio website
[ ] Interview preparation
[ ] Technical knowledge depth
[ ] Hands-on experience
[ ] Networking
[ ] Confidence level
```

**Target Scores:**

- Technical Skills: 7-8/10 average
- Soft Skills: 7/10 average
- Portfolio Quality: 8/10 average
- Job Readiness: 8/10 average

**Overall Target: 7.5/10 = Job Ready!**

---

## 🎉 Graduation & Next Steps

### You're Ready When:

```
✅ You can deploy a production app to Kubernetes from scratch
✅ You can write Terraform to create infrastructure
✅ You can build a CI/CD pipeline
✅ You can debug a production issue
✅ You can explain your projects confidently
✅ You have a strong portfolio
✅ You pass mock technical interviews
✅ You feel confident applying for jobs
```

### Job Search Strategy:

1. **Update All Profiles** (Week 1)

   - GitHub README
   - LinkedIn
   - Resume
   - Portfolio site

2. **Start Applying** (Week 2+)

   - 5-10 applications per day
   - Focus on Junior DevOps roles
   - Apply to startups and mid-size companies
   - Network on LinkedIn

3. **Interview Preparation**

   - Practice LeetCode (basics)
   - Review your projects
   - Prepare STAR stories
   - Mock interviews

4. **Continuous Learning**
   - Keep building projects
   - Contribute to open source
   - Write blog posts
   - Stay active on GitHub

---

## 🚀 Bonus Resources

### Communities to Join:

- CNCF Slack
- Kubernetes Slack
- DevOps subreddit
- HashiCorp Community
- AWS Community Builders

### YouTube Channels:

- TechWorld with Nana
- DevOps Toolkit
- Cloud Native Computing Foundation
- HashiCorp

### Newsletters:

- KubeWeekly
- DevOps Weekly
- CNCF Newsletter

### Podcasts:

- Kubernetes Podcast
- DevOps Paradox
- Screaming in the Cloud

---

## 📝 Final Words

**You are now equipped with:**

- ✅ World-class development environment (90% setup quality)
- ✅ Comprehensive learning path (8-week intensive curriculum)
- ✅ Project-based approach (15+ real projects, 700+ hours)
- ✅ Clear success metrics (measurable outcomes)
- ✅ Career preparation guidance (resume, LinkedIn, interviews)

**Remember:**

- **Learning DevOps is an intense sprint in this bootcamp**
- **12-13 hours daily commitment is required**
- **Build in public** - Share your journey
- **Don't aim for perfection** - Ship and iterate
- **Network actively** - Engage with the community
- **Stay curious** - Technology evolves rapidly
- **Help others** - Teaching reinforces learning

**The only thing between you and a DevOps career is ACTION.**

**Stop reading. Start building. Ship daily. Get hired. 🚀**

---

## 🆘 Getting Help

### When Stuck:

1. Read error messages carefully
2. Google the exact error
3. Check documentation
4. Ask in community Slack
5. Post on Stack Overflow
6. Review your project code
7. Take a break and return fresh

### Support Channels:

- **GitHub Issues**: For template bugs
- **Discussions**: For questions
- **Community Slack**: Real-time help
- **Blog Comments**: Share experiences

---

**Now go build something amazing! The world needs more DevOps Engineers. 💪**

_Last Updated: February 2026_
