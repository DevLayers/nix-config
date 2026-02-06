#
# Security Operations (SecOps) Environment
#
# Vulnerability scanning, SAST/DAST, compliance, secrets management
#
{
  description = "Security Operations Development Environment";

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
            # Container Security
            # ============================================

            trivy                # Container vulnerability scanner
            grype                # Vulnerability scanner
            syft                 # SBOM generator
            dive                 # Analyze Docker images

            # Container signing
            cosign               # Container signing/verification
            crane                # Container registry tool

            # ============================================
            # Infrastructure Security
            # ============================================

            # IaC Security
            tfsec                # Terraform security scanner
            checkov              # Multi-IaC security scanner
            terrascan            # IaC security scanner

            # Kubernetes Security
            kubesec              # K8s security scanner
            kubescape            # K8s security platform
            kube-bench           # CIS benchmark checker

            # ============================================
            # Secrets Management
            # ============================================

            vault                # HashiCorp Vault
            sops                 # Secret encryption
            age                  # Modern encryption
            git-crypt            # Git encryption

            # Kubernetes secrets
            kubeseal             # Sealed Secrets

            # ============================================
            # SAST (Static Analysis)
            # ============================================

            semgrep              # Semantic code analysis
            # gitleaks is for secret scanning

            # Linters with security focus
            shellcheck           # Shell script analysis
            hadolint             # Dockerfile linter
            yamllint             # YAML linter

            # ============================================
            # Secret Scanning
            # ============================================

            gitleaks             # Git secret scanner
            trufflehog           # Secret scanner

            # ============================================
            # Network Security
            # ============================================

            nmap                 # Network scanner
            masscan              # Fast port scanner
            tcpdump              # Packet analyzer
            wireshark            # Network protocol analyzer

            # ============================================
            # Web Security Testing
            # ============================================

            # Note: Many DAST tools are commercial or require separate installation
            # ZAP, Burp Suite, etc. are not in nixpkgs

            nuclei               # Vulnerability scanner

            # ============================================
            # Compliance & Auditing
            # ============================================

            # Open Policy Agent
            opa                  # Policy engine
            conftest             # Policy testing

            # ============================================
            # SSL/TLS Testing
            # ============================================

            openssl              # SSL/TLS toolkit
            # testssl.sh would need to be added separately

            # ============================================
            # Penetration Testing
            # ============================================

            metasploit           # Penetration testing framework
            sqlmap               # SQL injection tool

            # ============================================
            # Monitoring & Logging
            # ============================================

            # Security monitoring
            falco                # Runtime security

            # ============================================
            # Utilities
            # ============================================

            jq                   # JSON processor
            yq-go                # YAML processor
            curl                 # HTTP client
            httpie               # User-friendly HTTP
            git                  # Version control

            # Password generation
            pwgen                # Password generator

            # Hashing
            hashcat              # Password cracking
          ];

          shellHook = ''
            echo "╔══════════════════════════════════════════════════════════════╗"
            echo "║          🔐 Security Operations Environment 🔐              ║"
            echo "╚══════════════════════════════════════════════════════════════╝"
            echo ""
            echo "📦 Security Tools:"
            echo ""
            echo "  🐳 Container Security:"
            echo "    • trivy:    $(trivy --version 2>&1 | head -n1 | awk '{print $2}' || echo 'N/A')"
            echo "    • grype:    $(grype version 2>&1 | grep Version | awk '{print $2}' || echo 'N/A')"
            echo "    • syft:     $(syft version 2>&1 | grep Version | awk '{print $2}' || echo 'N/A')"
            echo ""
            echo "  🏗️  IaC Security:"
            echo "    • tfsec:    $(tfsec --version 2>&1 | awk '{print $2}' || echo 'N/A')"
            echo "    • checkov:  $(checkov --version 2>&1 || echo 'N/A')"
            echo ""
            echo "  ☸️  K8s Security:"
            echo "    • kubescape: $(kubescape version 2>&1 || echo 'N/A')"
            echo "    • kube-bench: $(kube-bench version 2>&1 | grep Version | cut -d':' -f2 || echo 'N/A')"
            echo ""
            echo "  🔑 Secrets Management:"
            echo "    • vault:    $(vault version 2>&1 | awk '{print $2}' || echo 'N/A')"
            echo "    • sops:     $(sops --version 2>&1 || echo 'N/A')"
            echo ""
            echo "🔧 Common Security Tasks:"
            echo ""
            echo "  Container Scanning:"
            echo "    trivy image nginx:latest"
            echo "    grype nginx:latest"
            echo "    syft nginx:latest -o json | jq"
            echo ""
            echo "  IaC Scanning:"
            echo "    tfsec ."
            echo "    checkov -d ."
            echo "    terrascan scan -t terraform"
            echo ""
            echo "  Secret Scanning:"
            echo "    gitleaks detect --source=."
            echo "    trufflehog git file://."
            echo ""
            echo "  Kubernetes Security:"
            echo "    kubescape scan framework nsa"
            echo "    kube-bench run --targets master"
            echo "    kubesec scan pod.yaml"
            echo ""
            echo "  SAST Analysis:"
            echo "    semgrep --config=auto ."
            echo "    shellcheck script.sh"
            echo "    hadolint Dockerfile"
            echo ""
            echo "  Secrets Management:"
            echo "    vault kv put secret/myapp password=secure123"
            echo "    sops --encrypt secrets.yaml > secrets.enc.yaml"
            echo ""
            echo "  Network Scanning:"
            echo "    nmap -sV -sC target.com"
            echo "    masscan -p1-65535 10.0.0.0/8"
            echo ""
            echo "⚠️  Security Best Practices:"
            echo "  1. Scan all container images before deployment"
            echo "  2. Never commit secrets to Git"
            echo "  3. Use IaC security scanning in CI/CD"
            echo "  4. Implement least privilege access"
            echo "  5. Regular security audits and penetration testing"
            echo "  6. Keep dependencies updated"
            echo ""

            export PROJECT_ROOT=$PWD
            export VAULT_ADDR=''${VAULT_ADDR:-http://127.0.0.1:8200}
            export SOPS_AGE_KEY_FILE=''${SOPS_AGE_KEY_FILE:-$HOME/.config/sops/age/keys.txt}

            # Create security directories
            mkdir -p "$PWD/security-reports" "$PWD/scan-results"
          '';
        };
      });
}
