#!/usr/bin/env bash
set -euo pipefail

TEMPLATE_NAME=${1:-}

if [ -z "$TEMPLATE_NAME" ]; then
  echo "Usage: $0 <template-name>"
  echo ""
  echo "Example: $0 my-template"
  exit 1
fi

TEMPLATE_DIR="templates/$TEMPLATE_NAME"

if [ -d "$TEMPLATE_DIR" ]; then
  echo "Error: Template '$TEMPLATE_NAME' already exists at $TEMPLATE_DIR"
  exit 1
fi

echo "Creating template: $TEMPLATE_NAME"
echo ""

mkdir -p "$TEMPLATE_DIR"/{examples,docs}

# Create flake.nix
cat > "$TEMPLATE_DIR/flake.nix" <<'EOF'
#
# TODO: Add template description
#
{
  description = "TODO: Add description";

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
            # TODO: Add packages
          ];

          shellHook = ''
            echo "╔══════════════════════════════════════════════════════════════╗"
            echo "║            Template environment ready!                       ║"
            echo "╚══════════════════════════════════════════════════════════════╝"
            echo ""
          '';
        };
      });
}
EOF

# Create .gitignore
cat > "$TEMPLATE_DIR/.gitignore" <<'EOF'
# Nix
result
result-*
.direnv
.envrc

# Logs
*.log
logs/

# OS
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# Misc
tmp/
temp/
EOF

# Create README.md
cat > "$TEMPLATE_DIR/README.md" <<EOF
# $TEMPLATE_NAME Template

TODO: Add description

## Quick Start

\`\`\`bash
nix flake init -t github:DevLayers/nix-config#$TEMPLATE_NAME
nix develop
\`\`\`

## What's Included

TODO: List tools

## Usage

TODO: Add examples
EOF

# Create .envrc.example
cat > "$TEMPLATE_DIR/.envrc.example" <<'EOF'
# Copy this to .envrc and run: direnv allow

# Use nix flake for development
use flake

# Project-specific environment variables
# export MYVAR=value
EOF

echo "✅ Template created at $TEMPLATE_DIR"
echo ""
echo "Next steps:"
echo "  1. Edit $TEMPLATE_DIR/flake.nix"
echo "  2. Update $TEMPLATE_DIR/README.md"
echo "  3. Add entry to templates/default.nix:"
echo ""
echo "     $TEMPLATE_NAME = {"
echo "       path = ./$TEMPLATE_NAME;"
echo "       description = \"TODO: Add description\";"
echo "     };"
echo ""
echo "  4. Test with: nix flake check $TEMPLATE_DIR"
echo "  5. Test with: cd /tmp && nix flake init -t path:$HOME/nix-config#$TEMPLATE_NAME"
