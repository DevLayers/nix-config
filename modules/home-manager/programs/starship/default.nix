{ ... }:
{
  # Starship configuration
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      
      # Performance: Reduce scan timeout for faster startup
      scan_timeout = 10;
      
      directory = {
        style = "bold lavender";
      };
      aws = {
        disabled = true;
      };
      docker_context = {
        symbol = " ";
      };
      golang = {
        symbol = " ";
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
        symbol = " ";
      };
      gradle = {
        symbol = " ";
      };
      java = {
        symbol = " ";
      };
      kotlin = {
        symbol = " ";
      };
      lua = {
        symbol = " ";
      };
      package = {
        symbol = " ";
      };
      php = {
        symbol = " ";
      };
      python = {
        symbol = " ";
      };
      rust = {
        symbol = " ";
      };
      terraform = {
        symbol = " ";
      };
      # Performance: Move kubernetes to left prompt instead of right (faster rendering)
      format = "$all$kubernetes$character";
      right_format = "";
    };
  };

  # Enable catppuccin theming for starship.
  catppuccin.starship.enable = true;
}
