#
# Multi-Cloud Development Environment
#
# CLIs for AWS, GCP, Azure, and other cloud providers
#
{
  description = "Multi-Cloud Development Environment";

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
            # AWS
            awscli2
            aws-vault
            
            # Google Cloud
            google-cloud-sdk
            
            # Azure
            azure-cli
            
            # DigitalOcean
            doctl
            
            # Hetzner
            hcloud
            
            # Multi-Cloud Tools
            pulumi
            terraform
            
            # Kubernetes (cloud-native)
            kubectl
            kubernetes-helm
            
            # Storage & Backup
            rclone
            restic
            
            # Utilities
            jq
            yq-go
            fzf
            
            # Network Tools
            curl
            httpie
            netcat
          ];

          shellHook = ''
            echo "╔══════════════════════════════════════════════════════════════╗"
            echo "║           ☁️  Multi-Cloud Development Environment ☁️        ║"
            echo "╚══════════════════════════════════════════════════════════════╝"
            echo ""
            echo "📦 Cloud Provider CLIs:"
            echo "  • AWS:             $(aws --version 2>&1 | cut -d' ' -f1 | cut -d'/' -f2 || echo 'N/A')"
            echo "  • GCP:             $(gcloud version 2>/dev/null | head -n1 | cut -d' ' -f4 || echo 'N/A')"
            echo "  • Azure:           $(az version 2>/dev/null | jq -r '."azure-cli"' || echo 'N/A')"
            echo "  • DigitalOcean:    $(doctl version 2>/dev/null | cut -d' ' -f3 || echo 'N/A')"
            echo ""
            echo "🔧 Quick Start:"
            echo ""
            echo "  AWS:"
            echo "    aws configure                    - Configure AWS credentials"
            echo "    aws s3 ls                        - List S3 buckets"
            echo "    aws ec2 describe-instances       - List EC2 instances"
            echo ""
            echo "  GCP:"
            echo "    gcloud init                      - Initialize gcloud"
            echo "    gcloud compute instances list    - List compute instances"
            echo "    gcloud container clusters list   - List GKE clusters"
            echo ""
            echo "  Azure:"
            echo "    az login                         - Login to Azure"
            echo "    az vm list                       - List VMs"
            echo "    az aks list                      - List AKS clusters"
            echo ""
            echo "💡 Credential Management:"
            echo "  • AWS credentials:    ~/.aws/credentials"
            echo "  • GCP credentials:    gcloud auth login"
            echo "  • Azure credentials:  az login"
            echo ""
            
            export PROJECT_ROOT=$PWD
            
            # Check for cloud credentials
            if [ -f "$HOME/.aws/credentials" ]; then
              echo "✅ AWS credentials found"
            fi
            
            if gcloud auth list --filter=status:ACTIVE 2>/dev/null | grep -q ACTIVE; then
              echo "✅ GCP credentials found"
            fi
            
            if az account show &>/dev/null; then
              echo "✅ Azure credentials found"
            fi
            echo ""
          '';
        };
      });
}
