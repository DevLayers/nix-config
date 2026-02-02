#
# CI/CD Development Environment
#
# Tools for continuous integration and deployment pipelines
#
{
  description = "CI/CD Development Environment";

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
            # GitHub Actions
            act                   # Run GitHub Actions locally
            gh                    # GitHub CLI
            
            # GitLab CI
            gitlab-runner         # GitLab CI runner
            glab                  # GitLab CLI
            
            # Container Building
            buildah               # Build OCI containers
            skopeo                # Container operations
            
            # Linting & Quality
            yamllint              # YAML linter
            actionlint            # GitHub Actions linter
            hadolint              # Dockerfile linter
            shellcheck            # Shell script linter
            
            # Security Scanning
            trivy                 # Container vulnerability scanner
            grype                 # Container vulnerability scanner
            syft                  # SBOM generator
            
            # Testing & Validation
            bats                  # Bash testing framework
            k6                    # Load testing
            
            # Secrets Management
            sops                  # Secrets encryption
            age                   # Encryption tool
            
            # Utilities
            jq
            yq-go
            git
            curl
          ];

          shellHook = ''
            echo "╔══════════════════════════════════════════════════════════════╗"
            echo "║            🔄 CI/CD Development Environment 🔄               ║"
            echo "╚══════════════════════════════════════════════════════════════╝"
            echo ""
            echo "📦 Installed Tools:"
            echo "  • act (GitHub Actions):  $(act --version 2>/dev/null | head -n1 || echo 'N/A')"
            echo "  • gitlab-runner:         $(gitlab-runner --version 2>/dev/null | head -n1 | cut -d' ' -f2 || echo 'N/A')"
            echo "  • trivy:                 $(trivy --version 2>/dev/null | head -n1 | cut -d' ' -f2 || echo 'N/A')"
            echo ""
            echo "🔧 GitHub Actions:"
            echo "  • act                    - Run GitHub Actions locally"
            echo "  • act -l                 - List available workflows"
            echo "  • act push               - Simulate push event"
            echo ""
            echo "🔧 GitLab CI:"
            echo "  • gitlab-runner exec docker <job>  - Run GitLab CI job locally"
            echo "  • glab ci view           - View pipeline status"
            echo ""
            echo "🔒 Security Scanning:"
            echo "  • trivy image <image>    - Scan container image"
            echo "  • trivy fs .             - Scan filesystem"
            echo "  • hadolint Dockerfile    - Lint Dockerfile"
            echo ""
            echo "✅ Linting:"
            echo "  • actionlint             - Lint GitHub Actions"
            echo "  • yamllint .             - Lint YAML files"
            echo "  • shellcheck script.sh   - Lint shell scripts"
            echo ""
            
            export PROJECT_ROOT=$PWD
            
            # Check for common CI files
            if [ -d ".github/workflows" ]; then
              echo "✅ Found GitHub Actions workflows"
              echo "   Run 'act -l' to list available workflows"
            fi
            
            if [ -f ".gitlab-ci.yml" ]; then
              echo "✅ Found GitLab CI configuration"
            fi
            
            if [ -f "Jenkinsfile" ]; then
              echo "✅ Found Jenkinsfile"
            fi
            echo ""
          '';
        };
      });
}
