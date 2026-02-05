{
  config,
  lib,
  ...
}: {
  config = {
    # Systemd login manager settings
    services.logind = {
      lidSwitch = "suspend";
      lidSwitchDocked = "ignore";
      lidSwitchExternalPower = "suspend";
      powerKey = "poweroff";

      # Automatically suspend after idle timeout
      extraConfig = ''
        IdleAction=suspend
        IdleActionSec=15min
        HandleLidSwitch=suspend
      '';
    };

    # Power management
    powerManagement = {
      enable = true;
      powertop.enable = true;
      cpuFreqGovernor = lib.mkDefault "powersave";
    };
  };
}
