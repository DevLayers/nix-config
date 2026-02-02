# Bash - Fallback shell configuration
{
  pkgs,
  lib,
  ...
}:
{
  programs.bash = {
    # XDG compliance - keep history in config directory
    # Prevents cluttering $HOME with .bash_history
    interactiveShellInit = ''
      export HISTFILE="$XDG_STATE_HOME"/bash_history
    '';

    # Initialize starship prompt for bash sessions
    # Ensures consistent prompt experience if switching from zsh
    promptInit = ''
      eval "$(${lib.getExe pkgs.starship} init bash)"
    '';
  };
}
