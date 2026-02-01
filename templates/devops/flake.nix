#
# DevOps Development Environment
#
# Includes: kubectl, helm, k9s, terraform, ansible, cloud CLIs, monitoring tools
#
{
  description = "Comprehensive DevOps Development Environment";

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
            # TIER 1: Critical DevOps Tools
            # ============================================
            
            # Kubernetes Essentials
            kubectl              # Kubernetes CLI
            kubernetes-helm      # Helm package manager
            k9s                  # Terminal UI for K8s
            kubectx              # Switch between K8s contexts
            kubens               # Switch between K8s namespaces
            
            # Cloud Provider CLIs
            awscli2              # AWS CLI v2
            google-cloud-sdk     # GCP CLI (gcloud)
            azure-cli            # Azure CLI
            
            # Infrastructure as Code
            terraform            # Terraform
            opentofu             # OpenTofu (Terraform fork)
            ansible              # Configuration management
            packer               # Image builder
            
            # CI/CD
            gitlab-runner        # GitLab CI runner
            act                  # Run GitHub Actions locally
            
            # ============================================
            # TIER 2: Highly Recommended
            # ============================================
            
            # Container Tools
            podman-compose       # Docker Compose for Podman
            dive                 # Analyze Docker images
            hadolint             # Dockerfile linter
            skopeo               # Container image operations
            
            # Kubernetes Extras
            kind                 # Kubernetes in Docker
            kustomize            # K8s config customization
            stern                # Multi-pod log tailing
            kubeseal             # Sealed Secrets
            
            # API & Data Tools
            httpie               # User-friendly HTTP client
            jq                   # JSON processor
            yq-go                # YAML processor
            fx                   # JSON viewer
            
            # Performance & Load Testing
            k6                   # Modern load testing
            vegeta               # HTTP load testing
            
            # Security & Scanning
            trivy                # Container vulnerability scanner
            checkov              # IaC security scanner
            tfsec                # Terraform security scanner
            
            # Backup & Storage
            restic               # Modern backup tool
            rclone               # Cloud storage sync
            
            # Network Tools
            mtr                  # Network diagnostics
            tcpdump              # Packet analyzer
            netcat               # TCP/UDP utility
            
            # Monitoring & Observability
            prometheus           # Metrics collection
            grafana              # Metrics visualization
            promtool             # Prometheus tooling
            
            # Git & Version Control
            git                  # Version control
            gh                   # GitHub CLI
            glab                 # GitLab CLI
            
            # Shell & Productivity
            direnv               # Environment switcher
            tmux                 # Terminal multiplexer
            fzf                  # Fuzzy finder
            ripgrep              # Fast grep
            bat                  # Cat with syntax highlighting
            eza                  # Modern ls
          ];

          shellHook = ''
            echo "╔══════════════════════════════════════════════════════════════╗"
            echo "║          🚀 DevOps Development Environment 🚀               ║"
            echo "╚══════════════════════════════════════════════════════════════╝"
            echo ""
            echo "📦 TIER 1 Tools (Critical):"
            echo "  • Kubernetes: kubectl, helm, k9s, kubectx"
            echo "  • Cloud: AWS, GCP, Azure CLIs"
            echo "  • IaC: Terraform, Ansible, Packer"
            echo "  • CI/CD: GitLab Runner, GitHub Actions"
            echo ""
            echo "🔧 TIER 2 Tools (Recommended):"
            echo "  • Containers: dive, hadolint, skopeo"
            echo "  • K8s Extras: kind, kustomize, stern"
            echo "  • Security: trivy, checkov, tfsec"
            echo "  • Testing: k6, vegeta"
            echo ""
            echo "📊 Version Information:"
            echo "  • kubectl:   $(kubectl version --client --short 2>/dev/null || echo 'N/A')"
            echo "  • terraform: $(terraform version -json 2>/dev/null | jq -r '.terraform_version' || echo 'N/A')"
            echo "  • ansible:   $(ansible --version 2>/dev/null | head -n1 | cut -d' ' -f2 || echo 'N/A')"
            echo "  • aws:       $(aws --version 2>/dev/null | cut -d' ' -f1 | cut -d'/' -f2 || echo 'N/A')"
            echo ""
            echo "💡 Quick Start:"
            echo "  • kubectl get nodes          # List K8s nodes"
            echo "  • k9s                        # Launch K8s TUI"
            echo "  • terraform init             # Initialize Terraform"
            echo "  • ansible-playbook play.yml  # Run Ansible playbook"
            echo ""
            export PROJECT_ROOT=$PWD
          '';
        };
      });
}
