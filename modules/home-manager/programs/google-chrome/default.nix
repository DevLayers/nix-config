{
  pkgs,
  lib,
  ...
}:
{
  # Ensure Google Chrome package is installed
  home.packages = lib.optionals (!pkgs.stdenv.hostPlatform.isDarwin) [ pkgs.google-chrome ];
}
