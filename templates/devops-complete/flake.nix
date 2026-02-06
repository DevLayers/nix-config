#
# Complete DevOps Environment
#
# All-in-one environment with every tool needed for daily DevOps work
#
{
  description = "Complete DevOps Environment - Everything You Need";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # DEFAULT: Everything for daily DevOps work
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # ═══════════════════════════════════════════════════════
            # CONTAINER & ORCHESTRATION
            # ═══════════════════════════════════════════════════════
            docker
            docker-compose
            kubectl
            kubernetes-helm
            k9s
            stern
            kustomize
            skaffold
            kubectx
            kubens

            # ═══════════════════════════════════════════════════════
            # INFRASTRUCTURE AS CODE
            # ═══════════════════════════════════════════════════════
            terraform
            terraform-ls
            tflint
            tfsec
            infracost
            ansible
            packer

            # ═══════════════════════════════════════════════════════
            # CLOUD PROVIDERS
            # ═══════════════════════════════════════════════════════
            awscli2
            google-cloud-sdk
            azure-cli
            doctl              # DigitalOcean

            # ═══════════════════════════════════════════════════════
            # GITOPS
            # ═══════════════════════════════════════════════════════
            argocd
            fluxcd
            sops
            age
            kubeseal

            # ═══════════════════════════════════════════════════════
            # MONITORING & OBSERVABILITY
            # ═══════════════════════════════════════════════════════
            prometheus
            grafana
            loki
            promtool
            logcli
            opentelemetry-collector

            # ═══════════════════════════════════════════════════════
            # SECURITY
            # ═══════════════════════════════════════════════════════
            trivy
            vault
            cosign
            checkov
            gitleaks
            kubescape

            # ═══════════════════════════════════════════════════════
            # CI/CD
            # ═══════════════════════════════════════════════════════
            github-cli
            gitlab-runner
            act

            # ═══════════════════════════════════════════════════════
            # DATABASES
            # ═══════════════════════════════════════════════════════
            postgresql
            redis
            mongodb

            # ═══════════════════════════════════════════════════════
            # UTILITIES
            # ═══════════════════════════════════════════════════════
            jq
            yq-go
            curl
            wget
            gnumake
            dive           # Docker image explorer
            httpie         # HTTP client
            git
            fzf
            ripgrep
            bat

            # Service Mesh
            istioctl
            linkerd
          ];

          shellHook = ''
            echo "╔══════════════════════════════════════════════════════════════╗"
            echo "║         🚀 Complete DevOps Environment 🚀                   ║"
            echo "╚══════════════════════════════════════════════════════════════╝"
            echo ""
            echo "📦 Container & Orchestration:"
            echo "  • Docker:     $(docker --version 2>/dev/null | cut -d' ' -f3 | tr -d ',' || echo 'N/A')"
            echo "  • Kubernetes: $(kubectl version --client -o json 2>/dev/null | jq -r .clientVersion.gitVersion || echo 'N/A')"
            echo "  • Helm:       $(helm version --short 2>/dev/null | cut -d':' -f2 || echo 'N/A')"
            echo ""
            echo "🏗️  Infrastructure as Code:"
            echo "  • Terraform:  $(terraform version -json 2>/dev/null | jq -r .terraform_version || echo 'N/A')"
            echo "  • Ansible:    $(ansible --version 2>/dev/null | head -n1 | cut -d' ' -f2 || echo 'N/A')"
            echo ""
            echo "☁️  Cloud Providers:"
            echo "  • AWS CLI:    $(aws --version 2>&1 | cut -d' ' -f1 | cut -d'/' -f2 || echo 'N/A')"
            echo "  • GCloud:     $(gcloud version 2>/dev/null | grep 'Google Cloud SDK' | cut -d' ' -f4 || echo 'N/A')"
            echo "  • Azure CLI:  $(az version 2>/dev/null | jq -r '."azure-cli"' || echo 'N/A')"
            echo ""
            echo "🔄 GitOps:"
            echo "  • ArgoCD:     $(argocd version --client --short 2>/dev/null | awk '{print $2}' || echo 'N/A')"
            echo "  • FluxCD:     $(flux version --client 2>/dev/null | grep 'flux:' | awk '{print $2}' || echo 'N/A')"
            echo ""
            echo "📊 Monitoring:"
            echo "  • Prometheus: $(prometheus --version 2>&1 | head -n1 | awk '{print $3}' || echo 'N/A')"
            echo "  • Grafana:    Available"
            echo ""
            echo "🔒 Security:"
            echo "  • Trivy:      $(trivy --version 2>/dev/null | cut -d' ' -f2 || echo 'N/A')"
            echo "  • Vault:      $(vault version 2>/dev/null | cut -d' ' -f2 || echo 'N/A')"
            echo ""
            echo "🛠️  Quick Commands:"
            echo "  • k9s                          - Kubernetes UI"
            echo "  • stern <pod> -n <namespace>   - Stream pod logs"
            echo "  • terraform plan               - Plan infrastructure"
            echo "  • argocd app list              - List ArgoCD apps"
            echo "  • trivy image <image>          - Scan container"
            echo "  • devops-info                  - Show current context"
            echo ""
            echo "📚 Available Environments:"
            echo "  • nix develop                  - Full DevOps (current)"
            echo "  • nix develop .#k8s-only       - Just Kubernetes tools"
            echo "  • nix develop .#infra-only     - Just Terraform/Cloud"
            echo "  • nix develop .#minimal        - Lightweight essentials"
            echo ""

            # Setup aliases
            alias k="kubectl"
            alias tf="terraform"
            alias kns="kubectl config set-context --current --namespace"
            alias kctx="kubectl config use-context"
            alias logs="stern"

            # Helper functions
            devops-info() {
              echo "════════════════════════════════════════════════"
              echo "Current Context Info"
              echo "════════════════════════════════════════════════"
              echo "Kubernetes Context:   $(kubectl config current-context 2>/dev/null || echo 'None')"
              echo "Kubernetes Namespace: $(kubectl config view --minify -o jsonpath='{..namespace}' 2>/dev/null || echo 'default')"
              echo "Terraform Workspace:  $(terraform workspace show 2>/dev/null || echo 'None')"
              echo "AWS Profile:          ''${AWS_PROFILE:-default}"
              echo "GCP Project:          $(gcloud config get-value project 2>/dev/null || echo 'None')"
              echo "════════════════════════════════════════════════"
            }

            export -f devops-info

            export PROJECT_ROOT=$PWD
          '';
        };

        # Kubernetes-focused environment
        devShells.k8s-only = pkgs.mkShell {
          buildInputs = with pkgs; [
            kubectl
            kubernetes-helm
            k9s
            stern
            kustomize
            kubectx
            kubens
            argocd
            fluxcd
            dive
            jq
            yq-go
          ];

          shellHook = ''
            echo "╔══════════════════════════════════════════════════════════════╗"
            echo "║          ☸️  Kubernetes-Only Environment ☸️                 ║"
            echo "╚══════════════════════════════════════════════════════════════╝"
            echo ""
            echo "Tools: kubectl, helm, k9s, stern, kustomize, argocd, flux"
            echo ""
            alias k="kubectl"
            alias logs="stern"
            alias kns="kubectl config set-context --current --namespace"
            alias kctx="kubectl config use-context"

            export KUBECONFIG=''${KUBECONFIG:-$HOME/.kube/config}
          '';
        };

        # Infrastructure-focused environment
        devShells.infra-only = pkgs.mkShell {
          buildInputs = with pkgs; [
            terraform
            terraform-ls
            tflint
            tfsec
            infracost
            ansible
            packer
            awscli2
            google-cloud-sdk
            azure-cli
            jq
            yq-go
          ];

          shellHook = ''
            echo "╔══════════════════════════════════════════════════════════════╗"
            echo "║        🏗️  Infrastructure-Only Environment 🏗️              ║"
            echo "╚══════════════════════════════════════════════════════════════╝"
            echo ""
            echo "Tools: terraform, ansible, packer, cloud CLIs"
            echo ""
            alias tf="terraform"

            export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
            mkdir -p "$TF_PLUGIN_CACHE_DIR"
          '';
        };

        # Minimal essential tools
        devShells.minimal = pkgs.mkShell {
          buildInputs = with pkgs; [
            kubectl
            kubernetes-helm
            terraform
            awscli2
            docker
            jq
            yq-go
            git
          ];

          shellHook = ''
            echo "╔══════════════════════════════════════════════════════════════╗"
            echo "║          ⚡ Minimal DevOps Environment ⚡                    ║"
            echo "╚══════════════════════════════════════════════════════════════╝"
            echo ""
            echo "Essentials: kubectl, helm, terraform, aws, docker"
            echo ""
          '';
        };
      });
}
