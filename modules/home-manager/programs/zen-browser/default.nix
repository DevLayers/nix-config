{
  pkgs,
  ...
}:
{
  # Zen Browser - Privacy-focused browser
  home.packages = [ pkgs.zen-browser ];

  xdg.mimeApps.defaultApplicationPackages = [ pkgs.zen-browser ];
}
