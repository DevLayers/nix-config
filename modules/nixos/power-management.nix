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
    };

    # Power management
    powerManagement = {
      enable = true;
      powertop.enable = true;
      cpuFreqGovernor = lib.mkDefault "powersave";
    };
  };
}
