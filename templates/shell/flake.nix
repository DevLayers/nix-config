#
# Shell Scripting Development Environment
#
# Bash, Zsh scripting with linting and testing tools
#
{
  description = "Shell Scripting Development Environment";

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
            # Shells
            bash                 # Bash shell
            zsh                  # Zsh shell

            # Linting & Analysis
            shellcheck           # Shell script analysis
            shfmt                # Shell script formatter

            # Testing
            bats                 # Bash testing framework

            # Documentation
            shellharden          # Shell hardening

            # Utilities
            jq                   # JSON processor
            yq-go                # YAML processor
            fzf                  # Fuzzy finder
            ripgrep              # Fast grep
            bat                  # Better cat
            eza                  # Modern ls

            # Text Processing
            gawk                 # AWK
            gnused               # sed
            gnugrep              # grep

            # Process Management
            parallel             # GNU parallel

            # Debugging
            bashdb               # Bash debugger
          ];

          shellHook = ''
            echo "╔══════════════════════════════════════════════════════════════╗"
            echo "║         🐚 Shell Scripting Environment 🐚                  ║"
            echo "╚══════════════════════════════════════════════════════════════╝"
            echo ""
            echo "📦 Installed Tools:"
            echo "  • Bash:       $(bash --version | head -n1)"
            echo "  • Zsh:        $(zsh --version)"
            echo "  • shellcheck: $(shellcheck --version | grep version | awk '{print $2}')"
            echo "  • shfmt:      $(shfmt --version)"
            echo "  • bats:       $(bats --version)"
            echo ""
            echo "🔧 Quick Start:"
            echo "  • shellcheck script.sh       - Lint shell script"
            echo "  • shfmt -w script.sh         - Format shell script"
            echo "  • bats test.bats             - Run tests"
            echo ""
            echo "💡 Best Practices:"
            echo "  1. Always use shellcheck"
            echo "  2. Use 'set -euo pipefail' at script start"
            echo "  3. Quote variables: \"\$var\""
            echo "  4. Use [[ ]] instead of [ ]"
            echo "  5. Write tests with bats"
            echo ""

            export PROJECT_ROOT=$PWD
          '';
        };
      });
}
