{
  config,
  lib,
  ...
}: {
  config = {
    # Systemd login manager settings
    services.logind.settings = {
      Login = {
        HandleLidSwitch = "suspend";
        HandleLidSwitchDocked = "ignore";
        HandleLidSwitchExternalPower = "suspend";
        HandlePowerKey = "poweroff";
      };
    };

    # Power management
    powerManagement = {
      enable = true;
      powertop.enable = true;
      cpuFreqGovernor = lib.mkDefault "powersave";
    };
  };
}
