#
# Platform Engineering Development Environment
#
# Tools for building internal developer platforms and platform-as-a-service
#
{
  description = "Platform Engineering Development Environment";

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
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # ============================================
            # Platform Orchestration
            # ============================================

            # Kubernetes
            kubectl              # Kubernetes CLI
            kubernetes-helm      # Helm package manager
            k9s                  # K8s terminal UI

            # Crossplane (K8s-based infrastructure)
            crossplane-cli       # Crossplane CLI

            # HashiCorp Stack
            terraform            # Infrastructure as Code
            vault                # Secrets management
            consul               # Service mesh
            nomad                # Workload orchestration
            waypoint             # Application deployment

            # ============================================
            # Developer Portal & Service Catalog
            # ============================================

            # Note: Backstage, Port.io require separate installation
            # These are typically run as services

            # API Documentation
            openapi-generator    # OpenAPI code generation

            # ============================================
            # GitOps & CI/CD
            # ============================================

            argocd               # GitOps CD
            fluxcd               # GitOps toolkit

            # CI/CD
            act                  # GitHub Actions locally
            gitlab-runner        # GitLab CI

            # ============================================
            # Service Mesh
            # ============================================

            istioctl             # Istio service mesh
            linkerd              # Linkerd service mesh

            # ============================================
            # Observability
            # ============================================

            prometheus           # Metrics
            grafana              # Visualization
            opentelemetry-collector  # Observability

            # Logging
            grafana-loki         # Log aggregation
            logcli               # Loki CLI

            # ============================================
            # Developer Experience
            # ============================================

            # Local development
            tilt                 # Local K8s dev
            skaffold             # K8s development
            devspace             # K8s dev environment
            telepresence         # Local K8s debugging

            # ============================================
            # API & Integration
            # ============================================

            grpcurl              # gRPC client
            evans                # gRPC client

            # ============================================
            # Policy & Governance
            # ============================================

            opa                  # Open Policy Agent
            conftest             # Policy testing

            # ============================================
            # Container & Registry
            # ============================================

            buildah              # Build containers
            skopeo               # Container operations
            crane                # Container registry tool

            # ============================================
            # Templating & Code Generation
            # ============================================

            cookiecutter         # Project templates
            copier               # Template rendering

            # ============================================
            # Documentation
            # ============================================

            mdbook               # Technical documentation

            # ============================================
            # Utilities
            # ============================================

            jq                   # JSON processor
            yq-go                # YAML processor
            fzf                  # Fuzzy finder
            ripgrep              # Fast grep
            bat                  # Better cat

            # Git tools
            git                  # Version control
            gh                   # GitHub CLI
            glab                 # GitLab CLI
          ];

          shellHook = ''
            echo "╔══════════════════════════════════════════════════════════════╗"
            echo "║        🏗️  Platform Engineering Environment 🏗️              ║"
            echo "╚══════════════════════════════════════════════════════════════╝"
            echo ""
            echo "📦 Platform Components:"
            echo ""
            echo "  ☸️  Orchestration:"
            echo "    • kubectl:    $(kubectl version --client --short 2>/dev/null | cut -d' ' -f3 || echo 'N/A')"
            echo "    • terraform:  $(terraform version -json 2>/dev/null | jq -r '.terraform_version' || echo 'N/A')"
            echo "    • crossplane: $(kubectl crossplane --version 2>&1 || echo 'N/A')"
            echo ""
            echo "  🔄 GitOps:"
            echo "    • argocd:     $(argocd version --client --short 2>&1 | awk '{print $2}' || echo 'N/A')"
            echo "    • flux:       $(flux version --client 2>&1 | grep flux | awk '{print $2}' || echo 'N/A')"
            echo ""
            echo "  🕸️  Service Mesh:"
            echo "    • istio:      $(istioctl version --remote=false 2>&1 | head -n1 || echo 'N/A')"
            echo "    • linkerd:    $(linkerd version --client --short 2>&1 || echo 'N/A')"
            echo ""
            echo "  🔑 Secrets & Policy:"
            echo "    • vault:      $(vault version 2>&1 | awk '{print $2}' || echo 'N/A')"
            echo "    • opa:        $(opa version 2>&1 | head -n1 || echo 'N/A')"
            echo ""
            echo "🔧 Platform Engineering Workflows:"
            echo ""
            echo "  Self-Service Platform:"
            echo "    • Create service templates with cookiecutter"
            echo "    • Define platform APIs with OpenAPI"
            echo "    • Automate provisioning with Crossplane/Terraform"
            echo "    • GitOps deployment with ArgoCD/Flux"
            echo ""
            echo "  Developer Experience:"
            echo "    tilt up                    # Start local dev environment"
            echo "    skaffold dev               # Live code reload"
            echo "    telepresence connect       # Connect local to cluster"
            echo ""
            echo "  Platform Operations:"
            echo "    kubectl crossplane install configuration <config>"
            echo "    argocd app create myapp --repo https://github.com/..."
            echo "    flux bootstrap github --owner=org --repository=fleet"
            echo ""
            echo "  Service Mesh:"
            echo "    istioctl install --set profile=demo"
            echo "    linkerd install | kubectl apply -f -"
            echo ""
            echo "💡 Platform Engineering Principles:"
            echo "  1. Self-service: Enable developers to deploy independently"
            echo "  2. Golden paths: Opinionated, easy defaults"
            echo "  3. Automation: Reduce manual toil"
            echo "  4. Observability: Built-in monitoring and logging"
            echo "  5. Security: Shift-left security practices"
            echo "  6. Documentation: Clear, accessible developer docs"
            echo ""
            echo "📚 Suggested Platform Capabilities:"
            echo "  • Service catalog (templates for common services)"
            echo "  • CI/CD pipelines (automated build/test/deploy)"
            echo "  • Environment provisioning (dev/staging/prod)"
            echo "  • Secrets management (centralized, encrypted)"
            echo "  • Observability stack (metrics, logs, traces)"
            echo "  • Policy enforcement (security, compliance)"
            echo ""

            export PROJECT_ROOT=$PWD
            export KUBECONFIG=''${KUBECONFIG:-$HOME/.kube/config}
            export VAULT_ADDR=''${VAULT_ADDR:-http://127.0.0.1:8200}

            # Create platform directories
            mkdir -p "$PWD/platform-templates" "$PWD/service-catalog" "$PWD/platform-docs"
          '';
        };
      });
}
