#
# GitOps Development Environment
#
# ArgoCD, FluxCD, and GitOps workflow tools
#
{
  description = "GitOps Development Environment";

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
            # GitOps Core Tools
            # ============================================

            # ArgoCD
            argocd               # ArgoCD CLI

            # FluxCD
            fluxcd               # Flux v2 CLI

            # ============================================
            # Kubernetes Tools
            # ============================================

            kubectl              # Kubernetes CLI
            kubernetes-helm      # Helm package manager
            kustomize            # K8s config customization
            k9s                  # Terminal UI for K8s

            # Context Management
            kubectx              # Switch contexts
            kubens               # Switch namespaces

            # ============================================
            # Secrets Management
            # ============================================

            sops                 # Secret encryption
            age                  # Modern encryption
            kubeseal             # Sealed Secrets

            # ============================================
            # Git & Version Control
            # ============================================

            git                  # Version control
            gh                   # GitHub CLI
            glab                 # GitLab CLI
            git-crypt            # Git encryption

            # ============================================
            # Manifest Tools
            # ============================================

            kustomize            # K8s customization
            kubeconform          # Manifest validation
            kube-score           # Best practices checker
            kubeval              # Manifest validation (legacy)

            # ============================================
            # Policy & Compliance
            # ============================================

            opa                  # Open Policy Agent
            conftest             # Policy testing

            # ============================================
            # CI/CD Integration
            # ============================================

            act                  # Run GitHub Actions locally
            gitlab-runner        # GitLab CI runner

            # ============================================
            # Monitoring & Observability
            # ============================================

            stern                # Multi-pod log tailing
            kubectl-tree         # Show resource hierarchy

            # ============================================
            # Utilities
            # ============================================

            jq                   # JSON processor
            yq-go                # YAML processor
            yamllint             # YAML linter
            fzf                  # Fuzzy finder
            ripgrep              # Fast grep
            bat                  # Better cat

            # Diff Tools
            dyff                 # YAML diff tool
            colordiff            # Colorized diff
          ];

          shellHook = ''
            echo "╔══════════════════════════════════════════════════════════════╗"
            echo "║              🔄 GitOps Development Environment 🔄           ║"
            echo "╚══════════════════════════════════════════════════════════════╝"
            echo ""
            echo "📦 GitOps Tools:"
            echo "  • ArgoCD:   $(argocd version --client --short 2>&1 | head -n1 | awk '{print $2}' || echo 'N/A')"
            echo "  • Flux:     $(flux version --client 2>&1 | grep 'flux:' | awk '{print $2}' || echo 'N/A')"
            echo "  • kubectl:  $(kubectl version --client --short 2>/dev/null | cut -d' ' -f3 || echo 'N/A')"
            echo "  • helm:     $(helm version --short 2>/dev/null | cut -d':' -f2 || echo 'N/A')"
            echo ""
            echo "🔧 ArgoCD Quick Start:"
            echo "  • argocd login <server>                  - Login to ArgoCD"
            echo "  • argocd app list                        - List applications"
            echo "  • argocd app sync <app>                  - Sync application"
            echo "  • argocd app diff <app>                  - Show diff"
            echo ""
            echo "🔧 Flux Quick Start:"
            echo "  • flux check --pre                       - Pre-flight check"
            echo "  • flux bootstrap github                  - Bootstrap Flux"
            echo "  • flux get all                           - Get all resources"
            echo "  • flux reconcile source git <name>       - Reconcile source"
            echo ""
            echo "🔐 Secrets Management:"
            echo "  • sops --encrypt secrets.yaml > secrets.enc.yaml"
            echo "  • sops --decrypt secrets.enc.yaml"
            echo "  • kubeseal --fetch-cert > pub-cert.pem"
            echo "  • kubeseal < secret.yaml > sealed-secret.yaml"
            echo ""
            echo "✅ Validation:"
            echo "  • kubeconform -strict manifest.yaml      - Validate K8s manifests"
            echo "  • kube-score score manifest.yaml         - Best practices check"
            echo "  • conftest test manifest.yaml            - Policy testing"
            echo ""
            echo "💡 GitOps Workflow:"
            echo "  1. Make changes in Git repository"
            echo "  2. Validate manifests locally"
            echo "  3. Commit and push to Git"
            echo "  4. GitOps tool syncs to cluster automatically"
            echo ""

            export PROJECT_ROOT=$PWD
            export KUBECONFIG=''${KUBECONFIG:-$HOME/.kube/config}
            export SOPS_AGE_KEY_FILE=''${SOPS_AGE_KEY_FILE:-$HOME/.config/sops/age/keys.txt}

            # Check for GitOps installation
            if kubectl get namespace argocd &>/dev/null; then
              echo "✅ ArgoCD detected in cluster"
            fi

            if kubectl get namespace flux-system &>/dev/null; then
              echo "✅ Flux detected in cluster"
            fi
            echo ""
          '';
        };
      });
}
