# Laptop Power Management - Battery optimization and thermal control
{ config, pkgs, lib, ... }:
let
  inherit (lib) mkIf;
  cfg = config.services;
  dev = config.modules.device;
  isLaptop = dev.type == "laptop" || dev.type == "hybrid";
in
{
  config = mkIf isLaptop {
    # ACPI backlight control (for adjusting screen brightness)
    hardware.acpilight.enable = true;

    environment.systemPackages = with pkgs; [
      acpi  # ACPI information tool (battery, thermal, AC adapter)
    ];

    services = {
      # ACPI event handler (lid close, power button, battery events)
      acpid = {
        enable = true;
        logEvents = true;  # Log ACPI events for debugging
      };

      # Disabled: using auto-cpufreq instead (configured in auto-cpufreq.nix)
      # power-profiles-daemon.enable = lib.mkDefault true;

      # Intel Undervolt (reduce CPU voltage to decrease heat and power consumption)
      # Target 65°C on battery to extend battery life and reduce fan noise
      undervolt = {
        enable = dev.cpu.type == "intel";
        tempBat = 65;  # Target temperature on battery (°C)
        package = pkgs.undervolt;
      };


      # UPower: Battery monitoring and power actions
      upower = {
        enable = true;
        percentageLow = 15;       # "Low battery" warning at 15%
        percentageCritical = 5;   # "Critical battery" warning at 5%
        percentageAction = 3;     # Trigger action at 3%
        criticalPowerAction = "Hibernate";  # Hibernate to prevent data loss
      };
    };

    # ACPI and CPU power management kernel modules
    boot = {
      kernelModules = ["acpi_call"];
      extraModulePackages = with config.boot.kernelPackages; [
        acpi_call  # ACPI call support for battery management
        cpupower   # CPU frequency scaling tools
      ];
    };

    # Laptop-specific power optimizations
    powerManagement = {
      enable = true;
      cpuFreqGovernor = lib.mkDefault "powersave";  # Default to powersave (auto-cpufreq overrides this)
    };
  };
}
