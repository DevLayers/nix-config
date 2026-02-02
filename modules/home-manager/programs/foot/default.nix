{ pkgs, lib, ... }:
{
  # Install foot via home-manager module (Linux/Wayland only)
  # On macOS, alacritty is used instead
  config = lib.mkIf (!pkgs.stdenv.isDarwin) {
    programs.foot = {
      enable = true;
      settings = {
        main = {
          shell = "${pkgs.zsh}/bin/zsh -l -c 'tmux attach || tmux'";
          font = "MesloLGS Nerd Font:size=12";
          dpi-aware = "yes";
        };

        scrollback = {
          lines = 10000;
          multiplier = 3;
        };

        cursor = {
          style = "block";
          blink = "yes";
        };

        mouse = {
          hide-when-typing = "yes";
        };
      };
    };

    # Enable catppuccin theming for foot.
    catppuccin.foot.enable = true;
  };
}
