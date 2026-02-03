{ ... }:
{
  # Starship configuration
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      
      # Performance: Reduce scan timeout for faster startup
      # Lower timeout means faster prompt rendering
      scan_timeout = 5;
      
      # Performance: Enable async command execution for faster prompt
      # This allows starship to show the prompt immediately while modules load in background
      command_timeout = 500;
      
      directory = {
        style = "bold lavender";
        # Performance: Limit directory truncation calculation
        truncation_length = 3;
        truncate_to_repo = true;
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
