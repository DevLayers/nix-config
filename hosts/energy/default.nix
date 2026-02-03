{
  inputs,
  hostname,
  nixosModules,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    "${nixosModules}/common"
    "${nixosModules}/desktop/niri"
    "${nixosModules}/programs/steam"
  ];

  # Hardware device configuration (CPU/GPU detection)
  modules.device = {
    type = "laptop";          # Laptop (enables power management, auto-cpufreq, undervolt)
    cpu.type = "intel";       # Intel CPU
    gpu.type = "intel";       # Intel integrated GPU
    monitors = ["eDP-1"];     # Laptop display
  };

  # System activation scripts
  modules.system.activation = {
    diffGenerations = true;   # Show package changes between generations
  };

  # Set hostname
  networking.hostName = hostname;

  # Ensure mount point directories exist for Windows partitions
  # This is needed so GTK bookmarks can reference these directories
  # even before the partitions are mounted
  systemd.tmpfiles.settings."ensure-mount-dirs" = {
    "/mnt/windows-c".d = {
      mode = "0755";
      user = "root";
      group = "root";
    };
    "/mnt/windows-d".d = {
      mode = "0755";
      user = "root";
      group = "root";
    };
    "/mnt/windows-e".d = {
      mode = "0755";
      user = "root";
      group = "root";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "26.05";
}
