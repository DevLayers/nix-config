{ ... }:
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
          timeout = 300; # 5 minutes
          on-timeout = "noctalia-shell ipc call lockScreen lock";
        }
        {
          timeout = 600; # 10 minutes - turn off screen
          on-timeout = "pidof Hyprland >/dev/null && hyprctl dispatch dpms off || niri msg action power-off-monitors";
          on-resume = "pidof Hyprland >/dev/null && hyprctl dispatch dpms on || niri msg action power-on-monitors";
        }
      ];
    };
  };
}
