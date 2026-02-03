{
  pkgs,
  lib,
  ...
}:
{
  # Zen Browser - Privacy-focused browser
  # Only include if the package exists in pkgs
  home.packages = lib.optional (pkgs ? zen-browser) pkgs.zen-browser;
}
