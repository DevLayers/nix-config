{
  pkgs,
  ...
}:
{
  # VSCode FHS (Filesystem Hierarchy Standard) version
  # This is better for extensions that require system libraries
  home.packages = [ pkgs.vscode-fhs ];

  xdg.mimeApps.defaultApplicationPackages = [ pkgs.vscode-fhs ];
}
