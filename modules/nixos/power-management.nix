{
  config,
  lib,
  pkgs,
  ...
}: {
  config = {
    # Systemd login manager settings
    services.logind = {
      lidSwitch = "suspend";
      lidSwitchDocked = "ignore";
      lidSwitchExternalPower = "suspend";
      powerKey = "poweroff";

      # Automatically lock after 5 minutes idle
      extraConfig = ''
        IdleAction=lock
        IdleActionSec=5min
        HandleLidSwitch=suspend
      '';
    };

    # Power management
    powerManagement = {
      enable = true;
      powertop.enable = true;
      cpuFreqGovernor = lib.mkDefault "powersave";
    };

    # Screen lock program
    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
    };

    # Wayland idle daemon (works with Niri)
    services.swayidle = {
      enable = true;
      systemdTarget = "graphical-session.target";
      timeouts = [
        {
          timeout = 300; # 5 minutes
          command = "${pkgs.swaylock-effects}/bin/swaylock -f -c 000000";
        }
        {
          timeout = 600; # 10 minutes
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
      events = [
        {
          event = "before-sleep";
          command = "${pkgs.swaylock-effects}/bin/swaylock -f -c 000000";
        }
        {
          event = "lock";
          command = "${pkgs.swaylock-effects}/bin/swaylock -f -c 000000";
        }
      ];
    };
  };
}
