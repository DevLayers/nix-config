# Direnv - Automatic environment switching for development
{ pkgs, ... }:
{
  programs.direnv = {
    enable = true;
    silent = true;  # Don't spam terminal with loading messages
    loadInNixShell = true;  # Load in nix-shell environments

    # Use nix-direnv for persistent, cached environments
    # This dramatically speeds up direnv by caching the nix shells
    nix-direnv.enable = true;
  };

  # Install direnv globally
  environment.systemPackages = with pkgs; [
    direnv
    nix-direnv
  ];
}
