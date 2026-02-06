#!/usr/bin/env bash
set -euo pipefail

TEMPLATES=(
  "devops"
  "devops-complete"
  "kubernetes"
  "terraform"
  "cloud"
  "cicd"
  "monitoring"
  "gitops"
  "sre"
  "secops"
  "platform-engineering"
  "python"
  "rust"
  "go"
  "node"
  "typescript"
  "java"
  "c"
  "php"
  "dotnet"
  "shell"
)

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║            Testing All Nix Flake Templates                   ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

FAILED_TEMPLATES=()
PASSED_TEMPLATES=()

for template in "${TEMPLATES[@]}"; do
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Testing template: $template"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  tmpdir=$(mktemp -d)

  if cd "$tmpdir"; then
    # Test template initialization
    if nix flake init -t "path:$HOME/nix-config#$template" 2>&1; then
      echo "  ✓ Template initialized"

      # Test flake check (if flake.nix exists)
      if [ -f "flake.nix" ]; then
        if nix flake check 2>&1; then
          echo "  ✓ Flake check passed"
        else
          echo "  ✗ Flake check failed"
          FAILED_TEMPLATES+=("$template (flake check)")
          cd - > /dev/null
          rm -rf "$tmpdir"
          continue
        fi

        # Test development shell
        if nix develop -c echo "Shell works" 2>&1; then
          echo "  ✓ Development shell works"
          PASSED_TEMPLATES+=("$template")
        else
          echo "  ✗ Development shell failed"
          FAILED_TEMPLATES+=("$template (dev shell)")
        fi
      else
        echo "  ⚠ No flake.nix found, skipping checks"
        PASSED_TEMPLATES+=("$template")
      fi
    else
      echo "  ✗ Template initialization failed"
      FAILED_TEMPLATES+=("$template (init)")
    fi

    cd - > /dev/null
    rm -rf "$tmpdir"
  else
    echo "  ✗ Failed to create temp directory"
    FAILED_TEMPLATES+=("$template (tmpdir)")
  fi

  echo ""
done

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                     Test Results                             ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "✅ Passed: ${#PASSED_TEMPLATES[@]}"
for template in "${PASSED_TEMPLATES[@]}"; do
  echo "  • $template"
done

echo ""
if [ ${#FAILED_TEMPLATES[@]} -eq 0 ]; then
  echo "🎉 All templates passed!"
  exit 0
else
  echo "❌ Failed: ${#FAILED_TEMPLATES[@]}"
  for template in "${FAILED_TEMPLATES[@]}"; do
    echo "  • $template"
  done
  exit 1
fi
