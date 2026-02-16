# DevOps Engineer Learning Path 🚀

A comprehensive 12-week roadmap to becoming a DevOps Engineer using this Nix-based template system.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Learning Path](#learning-path)
  - [Phase 1: Foundations (Weeks 1-3)](#phase-1-foundations-weeks-1-3)
  - [Phase 2: Container & Orchestration (Weeks 4-6)](#phase-2-container--orchestration-weeks-4-6)
  - [Phase 3: Observability & SRE (Weeks 7-9)](#phase-3-observability--sre-weeks-7-9)
  - [Phase 4: Advanced Topics (Weeks 10-12)](#phase-4-advanced-topics-weeks-10-12)
- [Template Usage Guide](#template-usage-guide)
- [Practical Projects](#practical-projects)
- [Career Progression](#career-progression)
- [Resources](#resources)

## Overview

This learning path is designed to take you from beginner to job-ready DevOps Engineer in 12–16 weeks, depending on how many hours per day you can commit. Each week focuses on specific skills and technologies, with hands-on projects using the templates in this repository.

> **Cloud focus:** This path intentionally focuses on **AWS** as the primary cloud. Multi-cloud (GCP, Azure, etc.) is a great **next step** once you’re comfortable with AWS.

**What You'll Learn:**

- Infrastructure as Code (Terraform, Ansible)
- Container Orchestration (Kubernetes)
- CI/CD Pipelines (GitHub Actions, GitLab CI)
- Cloud Platforms (AWS - primary focus)
- Observability (Prometheus, Grafana, Loki)
- GitOps (ArgoCD, FluxCD)
- Security & Compliance
- Platform Engineering

## Prerequisites

- **Basic Linux knowledge** - Navigate filesystem, use command line
- **Basic programming** - Any language (Python, Go, JavaScript recommended)
- **Git fundamentals** - Clone, commit, push, pull
- **Nix installed** - Follow [nix-config README](../README.md) for setup

## Learning Path

### Phase 1: Foundations (Weeks 1-3)

> **Core vs Stretch:** For each week, treat the “Hands-on Project” and core topics as **must-do**. Extra tools or side-projects are **stretch** and can be done later if you have time.

#### Week 1: Infrastructure as Code with Terraform

**Goal:** Learn to provision cloud infrastructure programmatically

**Template:** `terraform`

```bash
# Initialize your first IaC project
cd ~/learning/devops
nix flake init -t github:DevLayers/nix-config#terraform
```

**Topics:**

- Terraform basics (providers, resources, state)
- AWS fundamentals (VPC, EC2, EKS, RDS, S3, IAM)
- Infrastructure provisioning
- State management

**Hands-on Project:**

1. Create an AWS VPC with public/private subnets
2. Provision EC2 instances with security groups
3. Set up an RDS database
4. Use Terraform modules for reusability

**Daily Tasks:**

```bash
# Day 1-2: Terraform fundamentals
terraform init
terraform plan
terraform apply
terraform destroy

# Day 3-4: Multi-tier infrastructure
# Create VPC, subnets, routing tables, NAT gateway

# Day 5-7: Real project
# Deploy a 3-tier application (web, app, db)
```

**Security & Best Practices:**

```bash
# Run security scans
tfsec .
checkov -d .

# Generate documentation
terraform-docs md . > INFRASTRUCTURE.md
```

---

#### Week 2: Cloud Platforms Deep Dive

**Goal:** Master cloud provider CLIs and services

**Template:** `cloud`

```bash
cd ~/learning/cloud-mastery
nix flake init -t github:DevLayers/nix-config#cloud
```

**Topics:**

- AWS: EC2, S3, RDS, IAM, VPC, Lambda
- AWS: EC2, EKS, RDS, S3, VPC, Lambda, CloudFormation, Route53
- AWS Advanced: ECS, Fargate, DynamoDB, ElastiCache, CloudWatch, CloudTrail
- Multi-region AWS strategies

**Hands-on Project:**

1. Deploy a sample application stack on AWS (EC2, RDS, S3)
2. Implement backups and basic disaster recovery within AWS
3. Configure IAM roles and least-privilege access
4. Set up AWS-native monitoring and logging (CloudWatch, CloudTrail)

**Daily Tasks:**

```bash
# AWS (primary focus)
aws configure
aws s3 mb s3://my-bucket
aws ec2 run-instances --image-id ami-xxx --instance-type t2.micro
aws lambda create-function --function-name my-func
aws rds create-db-instance --db-instance-identifier mydb --db-instance-class db.t3.micro --engine postgres
aws cloudwatch describe-alarms
```

---

#### Week 3: CI/CD Pipelines

**Goal:** Automate build, test, and deployment workflows

**Template:** `cicd`

```bash
cd ~/learning/cicd-mastery
nix flake init -t github:DevLayers/nix-config#cicd
```

**Topics:**

- GitHub Actions workflows
- GitLab CI pipelines
- Container building and scanning
- Automated testing
- Deployment strategies

**Hands-on Project:**

1. Create a complete CI/CD pipeline for a web application
2. Implement automated testing (unit, integration)
3. Container security scanning
4. Multi-environment deployment (dev, staging, prod)

**Example Pipeline:**

```yaml
# .github/workflows/main.yml
name: CI/CD Pipeline
on: [push]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run tests
        run: |
          npm install
          npm test

  security:
    runs-on: ubuntu-latest
    steps:
      - name: Security scan
        run: |
          trivy fs .
          hadolint Dockerfile

  deploy:
    needs: [test, security]
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to production
        run: kubectl apply -f k8s/
```

**Testing Locally:**

```bash
# Test GitHub Actions locally
act push

# Scan for vulnerabilities
trivy fs .
trivy image myapp:latest

# Lint files
actionlint
yamllint .github/workflows/
```

---

### Phase 2: Container & Orchestration (Weeks 4-6)

#### Week 4: Kubernetes Fundamentals

**Goal:** Deploy and manage containerized applications on Kubernetes

**Template:** `kubernetes`

```bash
cd ~/learning/k8s-fundamentals
nix flake init -t github:DevLayers/nix-config#kubernetes
```

**Topics:**

- Kubernetes architecture (pods, services, deployments)
- kubectl commands
- YAML manifests
- ConfigMaps and Secrets
- Ingress and networking

**Hands-on Project:**

1. Create a local Kubernetes cluster with `kind`
2. Deploy a microservices application
3. Implement service discovery
4. Configure ingress routing
5. Set up persistent storage

**Daily Tasks:**

```bash
# Day 1: Cluster setup
kind create cluster --name learning
kubectl cluster-info
k9s  # Explore with K9s TUI

# Day 2-3: Deployments
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=LoadBalancer
kubectl scale deployment nginx --replicas=3

# Day 4-5: Advanced concepts
kubectl apply -f manifests/
kubectl rollout status deployment/myapp
kubectl rollout undo deployment/myapp

# Day 6-7: Real microservices project
# Deploy frontend, backend, database, redis cache
```

**Debugging:**

```bash
# View logs
stern myapp --since 15m

# Debug pods
kubectl describe pod myapp-xxx
kubectl exec -it myapp-xxx -- /bin/sh

# Port forwarding
kubectl port-forward svc/myapp 8080:80
```

---

#### Week 5: Helm & Kustomize

**Goal:** Package and customize Kubernetes applications

**Template:** `kubernetes`

**Topics:**

- Helm charts
- Helm values and templating
- Kustomize overlays
- Chart repositories

**Hands-on Project:**

1. Create a Helm chart for your application
2. Use Kustomize for environment-specific configs
3. Deploy to multiple environments
4. Set up a Helm chart repository

**Daily Tasks:**

```bash
# Helm basics
helm create myapp
helm install myapp ./myapp
helm upgrade myapp ./myapp
helm rollback myapp

# Kustomize
kustomize build overlays/production | kubectl apply -f -
kubectl apply -k overlays/staging

# Validate manifests
kubeconform -strict deployment.yaml
kube-score score deployment.yaml
```

---

#### Week 6: GitOps Workflow

**Goal:** Implement GitOps with ArgoCD and FluxCD

**Template:** `gitops`

```bash
cd ~/learning/gitops-workflow
nix flake init -t github:DevLayers/nix-config#gitops
```

**Topics:**

- GitOps principles
- ArgoCD installation and configuration
- FluxCD setup
- Automated synchronization
- Secret management with Sealed Secrets

**Hands-on Project:**

1. Set up GitOps repository structure
2. Install and configure ArgoCD
3. Implement automated deployments
4. Manage secrets securely
5. Set up notifications and monitoring

**Daily Tasks:**

```bash
# ArgoCD
argocd login <server>
argocd app create myapp \
  --repo https://github.com/user/repo \
  --path k8s \
  --dest-namespace default \
  --dest-server https://kubernetes.default.svc

# FluxCD
flux bootstrap github \
  --owner=myuser \
  --repository=fleet \
  --path=clusters/production

# Sealed Secrets
kubeseal --fetch-cert > pub-cert.pem
kubectl create secret generic mysecret --dry-run=client -o yaml | \
  kubeseal -o yaml > sealed-secret.yaml

# Validate policies
conftest test deployment.yaml
```

---

### Phase 3: Observability & SRE (Weeks 7-9)

#### Week 7: Monitoring & Metrics

**Goal:** Implement comprehensive monitoring with Prometheus and Grafana

**Template:** `monitoring`

```bash
cd ~/learning/observability
nix flake init -t github:DevLayers/nix-config#monitoring
```

**Topics:**

- Prometheus metrics collection
- Grafana dashboards
- AlertManager configuration
- Service monitoring
- Custom metrics

**Hands-on Project:**

1. Deploy Prometheus stack to Kubernetes
2. Create custom Grafana dashboards
3. Set up alerting rules
4. Monitor application and infrastructure
5. Implement SLO/SLI tracking

**Daily Tasks:**

```bash
# Start Prometheus locally
prometheus --config.file=prometheus.yml

# Start Grafana
grafana-server --homepath /usr/share/grafana

# Query metrics
promtool query instant http://localhost:9090 'up'
promtool query instant http://localhost:9090 'rate(http_requests_total[5m])'

# Load testing
k6 run load-test.js
vegeta attack -rate=50 -duration=30s -targets=targets.txt | vegeta report
```

---

#### Week 8: Logging & Tracing

**Goal:** Implement centralized logging and distributed tracing

**Template:** `monitoring`

**Topics:**

- Loki log aggregation
- Fluentd/Vector log shipping
- Jaeger distributed tracing
- OpenTelemetry
- Log analysis

**Hands-on Project:**

1. Deploy Loki stack
2. Configure log collection from all services
3. Set up distributed tracing with Jaeger
4. Implement OpenTelemetry instrumentation
5. Create log-based alerts

**Daily Tasks:**

```bash
# Loki
loki -config.file=loki-config.yml
logcli query '{app="myapp"}' --since=1h

# Query logs
logcli query '{namespace="production"} |= "error"' --tail

# Trace analysis
# Access Jaeger UI and analyze request traces
```

---

#### Week 9: SRE Practices

**Goal:** Master Site Reliability Engineering practices

**Template:** `sre`

```bash
cd ~/learning/sre-practices
nix flake init -t github:DevLayers/nix-config#sre
```

**Topics:**

- SLO/SLI/SLA definitions
- Error budgets
- Incident response
- Postmortem culture
- Database operations
- Backup and disaster recovery

**Hands-on Project:**

1. Define SLOs for your application
2. Set up automated backups
3. Create incident response runbooks
4. Implement chaos engineering tests
5. Write a postmortem template

**Daily Tasks:**

```bash
# Database backups
restic init --repo /backup/postgres
restic backup /var/lib/postgresql/data

# Performance testing
sysbench cpu run
pgbench -i mydb
pgbench -c 10 -j 2 -t 10000 mydb

# Database management
pgcli -h localhost -U postgres
mycli -h localhost -u root

# System monitoring
htop
iotop
nethogs
```

---

### Phase 4: Advanced Topics (Weeks 10-12)

#### Week 10: Security & Compliance

**Goal:** Implement security best practices and compliance

**Template:** `secops`

```bash
cd ~/learning/security
nix flake init -t github:DevLayers/nix-config#secops
```

**Topics:**

- Container security scanning
- Secrets management with Vault
- Policy as Code with OPA
- Compliance automation
- SAST/DAST tools
- Zero-trust security

**Hands-on Project:**

1. Implement automated security scanning in CI/CD
2. Set up HashiCorp Vault for secrets
3. Create OPA policies for Kubernetes
4. Scan infrastructure for vulnerabilities
5. Implement security incident response

**Daily Tasks:**

```bash
# Container scanning
trivy image nginx:latest
grype nginx:latest
syft nginx:latest -o json

# IaC security
tfsec .
checkov -d .
terrascan scan

# Secret management
vault server -dev
vault kv put secret/myapp password=secure123
vault kv get secret/myapp

# Kubernetes security
kubescape scan framework nsa
kube-bench run --targets master
kubesec scan pod.yaml

# Secret scanning
gitleaks detect --source=.
trufflehog git file://.

# Policy testing
conftest test deployment.yaml --policy policy/
opa test policy/
```

---

#### Week 11: Platform Engineering

**Goal:** Build internal developer platforms

**Template:** `platform-engineering`

```bash
cd ~/learning/platform-engineering
nix flake init -t github:DevLayers/nix-config#platform-engineering
```

**Topics:**

- Self-service infrastructure
- Developer portals (Backstage concepts)
- Crossplane for cloud resources
- Service templates and catalogs
- Platform APIs

**Hands-on Project:**

1. Create service templates with Cookiecutter
2. Implement Crossplane for infrastructure provisioning
3. Build a self-service deployment pipeline
4. Create platform documentation
5. Implement policy guardrails

**Daily Tasks:**

```bash
# Service templates
cookiecutter template-service
copier copy template-service myservice

# Crossplane
kubectl crossplane install configuration platform-config
kubectl get compositions

# Local development
tilt up
skaffold dev
telepresence connect

# Service mesh
istioctl install --set profile=demo
linkerd install | kubectl apply -f -
```

---

#### Week 12: Integration & Capstone Project

**Goal:** Build a complete production-ready platform

**Template:** `devops` (comprehensive)

```bash
cd ~/capstone-project
nix flake init -t github:DevLayers/nix-config#devops
```

**Capstone Project Requirements:**

Build a complete DevOps platform that includes:

1. **Infrastructure**: Multi-region AWS deployment (us-east-1, us-west-2, eu-west-1)
2. **Application**: Microservices architecture (3+ services)
3. **CI/CD**: Fully automated pipeline with quality gates
4. **Orchestration**: Kubernetes cluster with GitOps
5. **Observability**: Metrics, logs, and traces
6. **Security**: Automated scanning, secrets management, policies
7. **Documentation**: Architecture diagrams, runbooks, postmortems

**Architecture Example:**

```
┌─────────────────────────────────────────────────────────────┐
│                        Git Repository                        │
│                    (Single Source of Truth)                  │
└──────────────────┬──────────────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────────────┐
│                     CI/CD Pipeline                           │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │  Build   │→ │   Test   │→ │ Security │→ │  Deploy  │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
└──────────────────┬──────────────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────────────┐
│                  Kubernetes Cluster                          │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐            │
│  │  Frontend  │  │  Backend   │  │  Database  │            │
│  │  Service   │→ │  Service   │→ │  Service   │            │
│  └────────────┘  └────────────┘  └────────────┘            │
│                                                              │
│  Observability Stack:                                       │
│  Prometheus + Grafana + Loki + Jaeger                       │
└─────────────────────────────────────────────────────────────┘
```

---

## Template Usage Guide

### Quick Start with Any Template

```bash
# 1. Navigate to your project directory
cd ~/projects/my-new-project

# 2. Initialize with a template
nix flake init -t github:DevLayers/nix-config#<template-name>

# 3. Enter the development environment
nix develop

# 4. Start working!
```

### Available Templates

| Template               | Use Case                     | Key Tools                                   |
| ---------------------- | ---------------------------- | ------------------------------------------- |
| `devops`               | Comprehensive DevOps toolkit | kubectl, terraform, ansible, k9s, helm      |
| `terraform`            | Infrastructure as Code       | terraform, tfsec, tflint, cloud CLIs        |
| `kubernetes`           | Container orchestration      | kubectl, helm, k9s, kustomize, stern        |
| `cloud`                | AWS cloud development        | AWS CLI, eksctl, aws-vault, AWS SAM         |
| `cicd`                 | CI/CD pipelines              | act, gitlab-runner, trivy, hadolint         |
| `monitoring`           | Observability                | prometheus, grafana, loki, jaeger           |
| `gitops`               | GitOps workflows             | argocd, fluxcd, kustomize, sops             |
| `sre`                  | Site reliability             | database tools, backup, performance testing |
| `secops`               | Security operations          | trivy, vault, tfsec, kubescape              |
| `platform-engineering` | Platform building            | crossplane, istio, cookiecutter             |

### Combining Templates

For complex projects, you can combine tools from multiple templates:

```bash
# Start with the most relevant template
nix flake init -t github:DevLayers/nix-config#devops

# Then add tools from other templates by editing flake.nix
# Copy buildInputs from other templates as needed
```

---

## Practical Projects

### Project 1: Three-Tier Web Application

**Technologies:** Terraform, Kubernetes, CI/CD

**Steps:**

1. Provision AWS infrastructure with Terraform
2. Deploy PostgreSQL database
3. Deploy backend API (Node.js/Go/Python)
4. Deploy frontend (React/Vue)
5. Set up CI/CD pipeline
6. Implement monitoring

### Project 2: Multi-Region AWS Kubernetes

**Technologies:** Kubernetes, GitOps, Monitoring

**Steps:**

1. Create K8s clusters on AWS EKS in multiple regions (us-east-1, us-west-2, eu-west-1)
2. Implement GitOps with ArgoCD
3. Deploy microservices to all regional clusters
4. Set up Route53 for geo-routing and failover
5. Implement unified monitoring across regions

### Project 3: Internal Developer Platform

**Technologies:** Platform Engineering, GitOps, Security

**Steps:**

1. Create service templates
2. Implement Crossplane for resource provisioning
3. Set up GitOps automation
4. Add security scanning and policies
5. Create developer documentation portal

---

## Career Progression

### Junior DevOps Engineer (0-2 years)

**Skills Focus:**

- ✅ Linux administration
- ✅ Git and version control
- ✅ Basic scripting (Bash, Python)
- ✅ CI/CD pipeline creation
- ✅ Container basics (Docker)
- ✅ Cloud provider fundamentals

**Templates to Master:**

- `cicd`, `cloud`, `terraform`

### Mid-Level DevOps Engineer (2-5 years)

**Skills Focus:**

- ✅ Kubernetes expertise
- ✅ Infrastructure as Code (Terraform, Ansible)
- ✅ GitOps workflows
- ✅ Monitoring and observability
- ✅ Security best practices
- ✅ Database operations

**Templates to Master:**

- `kubernetes`, `gitops`, `monitoring`, `sre`

### Senior DevOps Engineer (5+ years)

**Skills Focus:**

- ✅ Platform engineering
- ✅ Architecture design
- ✅ Multi-region AWS strategies
- ✅ SRE practices (SLOs, error budgets)
- ✅ Team leadership
- ✅ Incident management

**Templates to Master:**

- `platform-engineering`, `secops`, `devops`

### Staff/Principal DevOps Engineer

**Skills Focus:**

- ✅ Organizational transformation
- ✅ Platform strategy
- ✅ Cross-team collaboration
- ✅ Technical evangelism
- ✅ Innovation and R&D

**Templates to Master:**

- All templates + create custom ones for your organization

---

## Resources

### Online Learning

- **Kubernetes:** [kubernetes.io/docs](https://kubernetes.io/docs/)
- **Terraform:** [learn.hashicorp.com/terraform](https://learn.hashicorp.com/terraform)
- **Prometheus:** [prometheus.io/docs](https://prometheus.io/docs/)
- **CNCF Landscape:** [landscape.cncf.io](https://landscape.cncf.io)

### Books

- "The Phoenix Project" - Gene Kim
- "Site Reliability Engineering" - Google
- "Kubernetes in Action" - Marko Lukša
- "Terraform: Up & Running" - Yevgeniy Brikman
- "The DevOps Handbook" - Gene Kim et al.

### Certifications

1. **AWS Certified Solutions Architect - Associate**
2. **Certified Kubernetes Administrator (CKA)**
3. **Certified Kubernetes Application Developer (CKAD)**
4. **HashiCorp Certified: Terraform Associate**
5. **AWS Certified Solutions Architect - Associate**
6. **AWS Certified DevOps Engineer - Professional**

### Practice Platforms

- **Killercoda:** Free Kubernetes/Linux labs
- **AWS Free Tier:** Practice with real cloud resources
- **AWS Free Tier:** 12 months free tier for hands-on practice
- **Kind/Minikube:** Local Kubernetes clusters
- **GitHub Actions:** Free CI/CD for public repos

---

## Tips for Success

### Daily Habits

1. **Read documentation daily** - 30 minutes
2. **Practice on real projects** - Build, not just watch tutorials
3. **Join communities** - CNCF Slack, Reddit r/devops, Discord servers
4. **Write about what you learn** - Blog, Twitter, LinkedIn
5. **Contribute to open source** - Start small, grow gradually

### Learning Strategy

- **70% Hands-on Practice** - Build real projects
- **20% Reading/Watching** - Documentation, tutorials, courses
- **10% Teaching Others** - Blog posts, talks, mentoring

### Project Ideas

1. **Personal Infrastructure** - Host your own services
2. **Open Source Contribution** - Fix bugs, add features
3. **Company Projects** - Automate everything at work
4. **Community Projects** - Help non-profits with infrastructure
5. **Blog Platform** - DevOps blog with full automation

---

## Next Steps

1. **Week 1**: Start with Terraform template, build your first infrastructure
2. **Join Community**: CNCF Slack, DevOps subreddit
3. **Create GitHub Account**: Document your learning journey
4. **Set Daily Goals**: 2-4 hours of focused practice
5. **Build Portfolio**: GitHub with all your projects

---

## Support & Community

- **Questions?** Open an issue in this repository
- **Contributions:** Submit PRs to improve templates
- **Discussions:** Use GitHub Discussions for learning questions
- **Twitter/X:** Share your progress with #DevOps #NixOS

---

**Remember:** DevOps is a journey, not a destination. Focus on continuous learning, automation, and collaboration. Good luck! 🚀

_Updated: February 2026_
