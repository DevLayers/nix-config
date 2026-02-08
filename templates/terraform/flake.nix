#
# Terraform/IaC Development Environment
#
# Infrastructure as Code development with Terraform, OpenTofu, and related tools
#
{
  description = "Terraform/IaC Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Terraform
            terraform
            terraform-docs
            terraform-ls

            # OpenTofu (Terraform fork)
            opentofu

            # Linting & Security
            tflint
            tfsec
            checkov
            terrascan

            # Cloud Providers
            awscli2
            google-cloud-sdk
            azure-cli

            # Utilities
            jq
            yq-go
            graphviz  # For terraform graph

            # Terragrunt
            terragrunt

            # Packer
            packer

            # Ansible
            ansible
            ansible-lint

            # Advanced Terraform Tools
            infracost            # Cost estimation
            # terraform-rover is not available in nixpkgs
            driftctl             # Infrastructure drift detection

            # Version Management
            tfswitch             # Terraform version manager
          ];

          shellHook = ''
            echo "╔══════════════════════════════════════════════════════════════╗"
            echo "║         🏗️  Terraform/IaC Development Environment 🏗️        ║"
            echo "╚══════════════════════════════════════════════════════════════╝"
            echo ""
            echo "📦 Installed Tools:"
            echo "  • Terraform: $(terraform version -json 2>/dev/null | jq -r '.terraform_version' || echo 'N/A')"
            echo "  • OpenTofu:  $(tofu version -json 2>/dev/null | jq -r '.terraform_version' || echo 'N/A')"
            echo "  • Packer:    $(packer version 2>/dev/null || echo 'N/A')"
            echo "  • Ansible:   $(ansible --version 2>/dev/null | head -n1 | cut -d' ' -f2 || echo 'N/A')"
            echo ""
            echo "🔧 Workflow Commands:"
            echo "  • terraform init         - Initialize working directory"
            echo "  • terraform plan         - Preview changes"
            echo "  • terraform apply        - Apply infrastructure changes"
            echo "  • terraform destroy      - Destroy infrastructure"
            echo ""
            echo "🔒 Security & Linting:"
            echo "  • tfsec .                - Security scan Terraform code"
            echo "  • tflint                 - Lint Terraform files"
            echo "  • checkov -d .           - Policy-as-code scanning"
            echo ""
            echo "📊 Documentation:"
            echo "  • terraform-docs md .    - Generate documentation"
            echo "  • terraform graph | dot -Tpng > graph.png  - Visualize dependencies"
            echo ""

            # Create .terraform.lock.hcl if it doesn't exist
            if [ ! -f ".terraform.lock.hcl" ] && [ -f "main.tf" ]; then
              echo "💡 Tip: Run 'terraform init' to initialize this Terraform project"
            fi
            echo ""

            export PROJECT_ROOT=$PWD
            export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
            mkdir -p "$TF_PLUGIN_CACHE_DIR"
          '';
        };
      });
}
