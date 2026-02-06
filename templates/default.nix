_: {
  flake.templates = {
    python = {
      path = ./python; # Python
      description = "Python Development environment";
    };

    torch-basics = {
      path = ./ml/torch-basics;
      description = "A template for a basic machine learning project with PyTorch";
    };

    cpp-starter-kit = {
      path = ./ml/cpp-starter-kit;
      description = "A template for a c++ development project skeleton with CMake";
    };

    js-webapp-basics = {
      path = ./ml/js-webapp-basics;
      description = "A template for creating javascript/typescript web application development environment";
    };

    langchain-basics = {
      path = ./ml/langchain-basics;
      description = "A template for creating a langchain based LLM application";
    };

    pybind11-starter-kit = {
      path = ./ml/pybind11-starter-kit;
      description = "A template that creates a skeleton for a pybind11 module, including development environment and nix packaging";
    };

    maturin-basics = {
      path = ./ml/maturin-basics;
      description = "A template as the starting point for building a pyo3 (rust) based python package.";
    };

    c = {
      path = ./c; # C/C++
      description = "Development environment for C/C++";
    };

    rust = {
      path = ./rust; # Rust
      description = "Development environment for Rust";
    };

    node = {
      path = ./node; # NodeJS
      description = "Development environment for NodeJS";
    };

    go = {
      path = ./go; # golang
      description = "Development environment for Golang";
    };

    java = {
      path = ./java; # Java
      description = "Development environment for Java";
    };

    php = {
      path = ./php; # PHP
      description = "Development environment for PHP";
    };

    # ========================================
    # DEVOPS TEMPLATES
    # ========================================

    devops = {
      path = ./devops;
      description = "Comprehensive DevOps environment with kubectl, terraform, ansible, cloud CLIs, and monitoring tools";
    };

    kubernetes = {
      path = ./kubernetes;
      description = "Kubernetes development environment with kubectl, helm, k9s, and cluster management tools";
    };

    terraform = {
      path = ./terraform;
      description = "Terraform/IaC environment with terraform, opentofu, tfsec, and cloud provider CLIs";
    };

    cicd = {
      path = ./cicd;
      description = "CI/CD pipeline development with GitHub Actions, GitLab CI, and container security scanning";
    };

    cloud = {
      path = ./cloud;
      description = "Multi-cloud development environment with AWS, GCP, Azure, and DigitalOcean CLIs";
    };

    monitoring = {
      path = ./monitoring;
      description = "Observability stack with Prometheus, Grafana, Loki, Jaeger, and OpenTelemetry";
    };

    gitops = {
      path = ./gitops;
      description = "GitOps workflow with ArgoCD, FluxCD, Kustomize, and secrets management";
    };

    sre = {
      path = ./sre;
      description = "SRE toolkit with database tools, backup/restore, performance testing, and incident response";
    };

    secops = {
      path = ./secops;
      description = "Security operations with vulnerability scanning, SAST/DAST, secrets management, and compliance tools";
    };

    platform-engineering = {
      path = ./platform-engineering;
      description = "Platform engineering with Crossplane, service mesh, developer portals, and self-service infrastructure";
    };

    # ========================================
    # ADDITIONAL LANGUAGE TEMPLATES
    # ========================================

    typescript = {
      path = ./typescript;
      description = "TypeScript development with Node.js, Deno, Bun, and modern tooling";
    };

    shell = {
      path = ./shell;
      description = "Shell scripting environment with Bash/Zsh, shellcheck, shfmt, and bats testing";
    };

    dotnet = {
      path = ./dotnet;
      description = "Development environment for .NET/C#/F# with .NET SDK";
    };
  };
}
