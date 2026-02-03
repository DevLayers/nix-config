{
  pkgs,
  ...
}:
{
  # Cursor AI code editor
  home.packages = [ pkgs.cursor ];

  xdg.mimeApps.defaultApplicationPackages = [ pkgs.cursor ];
}
