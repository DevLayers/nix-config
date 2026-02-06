# Flake Templates

Development environment templates for various programming languages and DevOps workflows.

## Quick Start

```bash
# Navigate to your project directory
cd ~/projects/my-new-project

# Initialize with a template
nix flake init -t github:DevLayers/nix-config#<template-name>

# Enter the development environment
nix develop
```

## Available Templates

### Programming Languages

| Template     | Description            | Key Tools                   |
| ------------ | ---------------------- | --------------------------- |
| `python`     | Python development     | python, pip, poetry         |
| `rust`       | Rust development       | cargo, rustc, clippy        |
| `go`         | Go/Golang development  | go, gopls, delve            |
| `node`       | Node.js development    | node, npm, pnpm             |
| `typescript` | TypeScript development | node, deno, bun, typescript |
| `java`       | Java development       | jdk, maven, gradle          |
| `c`          | C/C++ development      | gcc, cmake, gdb             |
| `php`        | PHP development        | php, composer               |
| `dotnet`     | .NET/C#/F# development | dotnet-sdk, omnisharp       |
| `shell`      | Shell scripting        | bash, zsh, shellcheck, bats |

### Machine Learning

| Template               | Description                    |
| ---------------------- | ------------------------------ |
| `torch-basics`         | PyTorch machine learning       |
| `cpp-starter-kit`      | C++ development with CMake     |
| `js-webapp-basics`     | JavaScript/TypeScript web apps |
| `langchain-basics`     | LangChain LLM applications     |
| `pybind11-starter-kit` | Python-C++ bindings            |
| `maturin-basics`       | Rust-Python (PyO3) packages    |

### DevOps & Infrastructure

| Template               | Description                      | Key Tools                                                      |
| ---------------------- | -------------------------------- | -------------------------------------------------------------- |
| `devops`               | **Comprehensive DevOps toolkit** | kubectl, terraform, ansible, k9s, helm, vault, prometheus      |
| `kubernetes`           | Kubernetes development           | kubectl, helm, k9s, kustomize, stern, telepresence             |
| `terraform`            | Infrastructure as Code           | terraform, opentofu, tfsec, tflint, cloud CLIs                 |
| `cloud`                | Multi-cloud development          | AWS, GCP, Azure, DigitalOcean, Hetzner CLIs                    |
| `cicd`                 | CI/CD pipelines                  | GitHub Actions, GitLab CI, trivy, hadolint                     |
| `monitoring`           | **Observability stack**          | prometheus, grafana, loki, jaeger, opentelemetry               |
| `gitops`               | **GitOps workflows**             | argocd, fluxcd, kustomize, sops, kubeseal                      |
| `sre`                  | **Site Reliability Engineering** | database tools, backup, performance testing, incident response |
| `secops`               | **Security operations**          | trivy, vault, tfsec, kubescape, gitleaks, opa                  |
| `platform-engineering` | **Platform building**            | crossplane, istio, tilt, backstage tools                       |

## Usage Examples

### Start a Python Project

```bash
mkdir my-python-app && cd my-python-app
nix flake init -t github:DevLayers/nix-config#python
nix develop
```

### Start a Kubernetes Project

```bash
mkdir k8s-project && cd k8s-project
nix flake init -t github:DevLayers/nix-config#kubernetes
nix develop

# Create local cluster
kind create cluster

# Explore with K9s
k9s
```

### Start a Full DevOps Project

```bash
mkdir infrastructure && cd infrastructure
nix flake init -t github:DevLayers/nix-config#devops
nix develop

# You now have access to 50+ DevOps tools!
```

## Template Categories

### 🎯 For Beginners

- `python`, `node`, `shell` - Simple language templates
- `cicd` - Learn CI/CD basics
- `cloud` - Explore cloud providers

### 💼 For DevOps Engineers

- **Start with:** `terraform` → `kubernetes` → `gitops`
- **Then explore:** `monitoring` → `sre` → `secops`
- **Advanced:** `platform-engineering`, `devops`

See [DEVOPS-LEARNING-PATH.md](./DEVOPS-LEARNING-PATH.md) for a comprehensive 12-week roadmap.

### 🤖 For ML Engineers

- `torch-basics` - PyTorch projects
- `langchain-basics` - LLM applications
- `python` - General ML development

### 🏗️ For Platform Engineers

- `platform-engineering` - Self-service infrastructure
- `kubernetes` + `gitops` - Platform automation
- `monitoring` - Observability stack

## DevOps Learning Path

**Want to become a DevOps Engineer?** Check out our comprehensive guide:

📖 **[DevOps Learning Path](./DEVOPS-LEARNING-PATH.md)** - A 12-week roadmap with:

- Week-by-week learning objectives
- Hands-on projects for each topic
- Template usage instructions
- Career progression guidance
- Practical exercises and examples

## Customizing Templates

After initializing a template, you can customize the `flake.nix`:

```nix
{
  description = "My Custom Project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Add your tools here
            python3
            nodejs
            # ...
          ];

          shellHook = ''
            echo "Welcome to my project!"
          '';
        };
      });
}
```

## Benefits of Nix Templates

✅ **Reproducible** - Same environment on any machine
✅ **Isolated** - No global installations, no conflicts
✅ **Declarative** - Everything defined in code
✅ **Version-pinned** - Lock exact tool versions
✅ **Fast** - Binary caching, instant activation
✅ **Shareable** - Team gets identical environment

## Template Structure

Each template typically includes:

```
template-name/
├── flake.nix          # Nix configuration with tools
├── .envrc             # direnv integration (optional)
├── .gitignore         # Standard .gitignore
└── README.md          # Template-specific docs
```

## Combining Templates

For complex projects needing multiple toolsets:

1. **Start with base template:**

   ```bash
   nix flake init -t github:DevLayers/nix-config#devops
   ```

2. **Edit `flake.nix` to add tools from other templates:**

   ```nix
   buildInputs = with pkgs; [
     # From devops template
     kubectl terraform ansible

     # Add from python template
     python3 poetry

     # Add from monitoring template
     prometheus grafana
   ];
   ```

## Contributing

Contributions welcome! To add a new template:

1. Create directory in `templates/`
2. Add `flake.nix` with your tools
3. Register in `templates/default.nix`
4. Update this README
5. Submit a PR

## Common Issues

### Template Not Found

```bash
# Make sure you're using the correct syntax
nix flake init -t github:DevLayers/nix-config#terraform
#                                              ^^^^^^^^^ template name
```

### Missing Tools

If a tool is missing after entering the shell:

1. Check if it's in the template's `buildInputs`
2. Run `nix flake update` to refresh
3. Re-enter the shell with `nix develop`

### Direnv Integration

For automatic environment activation with direnv:

```bash
# In your project directory
echo "use flake" > .envrc
direnv allow
```

## Resources

- **Nix Manual:** https://nixos.org/manual/nix/stable/
- **Nix Flakes:** https://nixos.wiki/wiki/Flakes
- **Template Source:** https://github.com/DevLayers/nix-config/tree/master/templates

## License

See [LICENSE](../LICENSE) file.

---

**Pro Tip:** Bookmark this repository to quickly access templates:

```bash
# Add to your shell config
alias nix-template='nix flake init -t github:DevLayers/nix-config#'

# Usage
nix-template kubernetes
```
