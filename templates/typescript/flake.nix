#
# TypeScript Development Environment
#
# Modern TypeScript development with Node.js, Deno, and Bun support
#
{
  description = "TypeScript Development Environment";

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
            # JavaScript Runtimes
            nodejs_22            # Node.js LTS
            deno                 # Deno runtime
            bun                  # Bun runtime

            # Package Managers
            nodePackages.pnpm    # Fast package manager
            nodePackages.yarn    # Yarn package manager

            # TypeScript Tools
            typescript           # TypeScript compiler
            nodePackages.ts-node # TypeScript execution
            nodePackages.tsx     # Enhanced ts-node

            # Linting & Formatting
            nodePackages.eslint  # JavaScript linter
            nodePackages.prettier # Code formatter
            biome                # Fast linter/formatter

            # Build Tools
            nodePackages.vite    # Modern build tool
            esbuild              # Fast bundler

            # Testing
            nodePackages.vitest  # Fast test runner
            nodePackages.jest    # Testing framework

            # Type Checking
            nodePackages.typescript-language-server

            # Utilities
            jq                   # JSON processor
            yq-go                # YAML processor
          ];

          shellHook = ''
            echo "╔══════════════════════════════════════════════════════════════╗"
            echo "║         📘 TypeScript Development Environment 📘           ║"
            echo "╚══════════════════════════════════════════════════════════════╝"
            echo ""
            echo "📦 Installed Tools:"
            echo "  • Node.js:     $(node --version)"
            echo "  • Deno:        $(deno --version | head -n1)"
            echo "  • Bun:         $(bun --version)"
            echo "  • TypeScript:  $(tsc --version)"
            echo "  • pnpm:        $(pnpm --version)"
            echo ""
            echo "🔧 Quick Start:"
            echo "  • pnpm init                  - Initialize project"
            echo "  • pnpm add -D typescript     - Add TypeScript"
            echo "  • tsc --init                 - Create tsconfig.json"
            echo "  • tsx src/index.ts           - Run TypeScript file"
            echo ""
            echo "🚀 Build Tools:"
            echo "  • vite                       - Modern bundler"
            echo "  • esbuild                    - Fast bundler"
            echo ""

            export PROJECT_ROOT=$PWD
            export PATH="$PWD/node_modules/.bin:$PATH"
          '';
        };
      });
}
