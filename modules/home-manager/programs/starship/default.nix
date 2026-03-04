{ ... }:
{
  # Starship configuration
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;

      # Performance: Increase scan timeout to prevent timeout warnings
      # Default is 30ms. Set higher for large repos or slow filesystems.
      # If you see timeout warnings, increase this value.
      scan_timeout = 30;

      # Performance: Command timeout for external commands (git, etc.)
      # This allows starship to show the prompt immediately while modules load in background
      command_timeout = 1000;

      # Continuation prompt for multi-line commands
      continuation_prompt = "[∙](bold yellow) ";

      directory = {
        style = "bold lavender";
        # Performance: Limit directory truncation calculation
        truncation_length = 3;
        truncate_to_repo = true;
      };

      # Performance: Optimize git_status for faster rendering
      git_status = {
        # Faster git status with minimal features
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        untracked = "?\${count}";
        stashed = "󰜦 ";
        modified = "!\${count}";
        staged = "+\${count}";
        renamed = "»\${count}";
        deleted = "✘\${count}";
        # Disable expensive operations
        ignore_submodules = true;
      };

      aws = {
        disabled = true;
      };
      docker_context = {
        symbol = " ";
        # Performance: Only detect in relevant directories
        detect_files = ["docker-compose.yml" "docker-compose.yaml" "Dockerfile"];
      };
      golang = {
        symbol = " ";
        # Performance: Only detect in Go projects
        detect_extensions = ["go"];
        detect_files = ["go.mod" "go.sum"];
      };
      kubernetes = {
        disabled = false;
        style = "bold pink";
        symbol = "󱃾 ";
        format = "[$symbol$context( \($namespace\))]($style)";
        # Performance: Only detect k8s context in relevant directories
        detect_files = ["k8s" "kubernetes" "Chart.yaml" "helmfile.yaml"];
        detect_folders = ["k8s" "kubernetes" ".kube" "helm"];
        detect_extensions = [];
        contexts = [
          {
            context_pattern = "arn:aws:eks:(?P<var_region>.*):(?P<var_account>[0-9]{12}):cluster/(?P<var_cluster>.*)";
            context_alias = "$var_cluster";
          }
        ];
      };
      helm = {
        symbol = " ";
        detect_files = ["Chart.yaml"];
      };
      gradle = {
        symbol = " ";
        detect_files = ["build.gradle" "build.gradle.kts"];
      };
      java = {
        symbol = " ";
        detect_extensions = ["java"];
        detect_files = ["pom.xml" "build.gradle" "build.gradle.kts"];
      };
      kotlin = {
        symbol = " ";
        detect_extensions = ["kt" "kts"];
      };
      lua = {
        symbol = " ";
        detect_extensions = ["lua"];
        detect_files = [".lua-version"];
      };
      package = {
        symbol = " ";
      };
      php = {
        symbol = " ";
        detect_extensions = ["php"];
        detect_files = ["composer.json"];
      };
      python = {
        symbol = " ";
        detect_extensions = ["py"];
        detect_files = ["requirements.txt" "pyproject.toml" "Pipfile"];
      };
      rust = {
        symbol = " ";
        detect_extensions = ["rs"];
        detect_files = ["Cargo.toml"];
      };
      terraform = {
        symbol = " ";
        detect_extensions = ["tf" "tfvars"];
        detect_folders = [".terraform"];
      };
      # Performance: Move kubernetes to left prompt instead of right (faster rendering)
      format = "$all$kubernetes$character";
      right_format = "";
    };
  };

  # Enable catppuccin theming for starship.
  catppuccin.starship.enable = true;
}
