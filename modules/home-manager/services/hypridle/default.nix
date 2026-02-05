{ pkgs, ... }:
{
  # Manage Hypridle service via Home-manager
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        before_sleep_cmd = "noctalia-shell ipc call lockScreen lock";
        after_sleep_cmd = "pidof Hyprland >/dev/null && hyprctl dispatch dpms on || niri msg action power-on-monitors";
        lock_cmd = "noctalia-shell ipc call lockScreen lock";
      };

      listener = [
        {
          timeout = 240; # 4 minutes - dim screen
          on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10%";
          on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r";
        }
        {
          timeout = 300; # 5 minutes - lock screen
          on-timeout = "noctalia-shell ipc call lockScreen lock";
        }
        {
          timeout = 330; # 5.5 minutes - turn off keyboard backlight and display
          on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -sd platform::kbd_backlight set 0 && (pidof Hyprland >/dev/null && hyprctl dispatch dpms off || niri msg action power-off-monitors)";
          on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -rd platform::kbd_backlight && (pidof Hyprland >/dev/null && hyprctl dispatch dpms on || niri msg action power-on-monitors)";
        }
      ];
    };
  };
}
