#
# Kubernetes Development Environment
#
# Focused on K8s cluster management, manifest development, and debugging
#
{
  description = "Kubernetes Development Environment";

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
            # Core K8s Tools
            kubectl
            kubernetes-helm
            k9s
            
            # Context & Namespace Management
            kubectx
            kubens
            
            # Local K8s Clusters
            kind
            minikube
            
            # Manifest Tools
            kustomize
            kubeconform
            
            # Debugging & Logs
            stern
            
            # Package Management
            helmfile
            
            # Security
            kubeseal
            kubescape
            
            # GitOps
            argocd
            fluxcd
            
            # Service Mesh
            istioctl
            linkerd
            
            # Utilities
            jq
            yq-go
            fzf
            
            # YAML linting
            yamllint
          ];

          shellHook = ''
            echo "╔══════════════════════════════════════════════════════════════╗"
            echo "║         ☸️  Kubernetes Development Environment ☸️           ║"
            echo "╚══════════════════════════════════════════════════════════════╝"
            echo ""
            echo "📦 Installed Tools:"
            echo "  • kubectl  $(kubectl version --client --short 2>/dev/null | cut -d' ' -f3 || echo 'N/A')"
            echo "  • helm     $(helm version --short 2>/dev/null | cut -d' ' -f1 | cut -d':' -f2 || echo 'N/A')"
            echo "  • k9s      $(k9s version --short 2>/dev/null || echo 'N/A')"
            echo ""
            echo "🔧 Available Commands:"
            echo "  • kubectl get nodes      - List cluster nodes"
            echo "  • k9s                    - Launch K8s TUI"
            echo "  • kubectx                - Switch K8s context"
            echo "  • kubens                 - Switch namespace"
            echo "  • stern <pod-pattern>    - Tail multiple pod logs"
            echo "  • kind create cluster    - Create local cluster"
            echo ""
            
            # Check current context
            if kubectl cluster-info &>/dev/null; then
              CURRENT_CONTEXT=$(kubectl config current-context)
              CURRENT_NS=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null || echo "default")
              echo "✅ Connected to cluster:"
              echo "   Context:   $CURRENT_CONTEXT"
              echo "   Namespace: $CURRENT_NS"
            else
              echo "⚠️  No active Kubernetes cluster detected"
              echo "   Run 'kind create cluster' to create a local cluster"
            fi
            echo ""
            
            export PROJECT_ROOT=$PWD
            export KUBECONFIG=''${KUBECONFIG:-$HOME/.kube/config}
          '';
        };
      });
}
