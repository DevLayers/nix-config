{
  pkgs,
  ...
}:
{
  # Zen Browser - Privacy-focused browser
  home.packages = [ pkgs.zen-browser ];

  # Make Zen Browser the default for web links.
  xdg.mimeApps.defaultApplicationPackages = [ pkgs.zen-browser ];
}
