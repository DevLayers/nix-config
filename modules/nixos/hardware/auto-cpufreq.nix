# Auto-cpufreq - Automatic CPU frequency/governor management for ALL systems
{ config, pkgs, lib, ... }:
let
  inherit (lib) mkIf;
  dev = config.modules.device;
in
{
  config = {
    # Auto-cpufreq: Intelligent CPU frequency/governor switching
    # Works on laptops AND desktops for optimal performance + efficiency
    services.auto-cpufreq = {
      enable = true;

      settings = {
        # Battery mode (laptops only, ignored on desktops)
        battery = {
          governor = "powersave";
          scaling_min_freq = mkIf (dev.cpu.type == "intel") 1200000;
          scaling_max_freq = mkIf (dev.cpu.type == "intel") 2800000;
          turbo = "never";  # Disable turbo on battery to save power
        };

        # AC/Charger mode (laptops) or default mode (desktops)
        charger = {
          governor = "performance";
          scaling_min_freq = mkIf (dev.cpu.type == "intel") 1800000;
          scaling_max_freq = mkIf (dev.cpu.type == "intel") 3500000;
          turbo = "auto";  # Enable turbo for performance
        };
      };
    };
  };
}
