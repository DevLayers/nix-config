{ pkgs, ... }:
{
  # Enable GDM display manager
  services.displayManager.gdm.enable = true;

  # Enable Power management support
  # Disabled: using auto-cpufreq instead for better automatic CPU management
  # services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # Enable security services
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;
  security.pam.services = {
    gdm.enableGnomeKeyring = true;
  };

  # Enable GVFS for virtual file system support (needed for file managers to show all partitions)
  services.gvfs.enable = true;

  # Enable udisks2 for disk management and auto-mounting (needed to detect and mount storage devices)
  services.udisks2.enable = true;

  # Common packages for Wayland compositors
  environment.systemPackages = with pkgs; [
    # GNOME apps
    file-roller # archive manager
    gnome-calculator
    gnome-pomodoro
    gnome-text-editor
    loupe # image viewer
    nautilus # file manager
    seahorse # keyring manager
    totem # Video player

    # Wayland utilities
    gpu-screen-recorder
    grim
    libnotify
    pamixer
    pavucontrol
    slurp
  ];
}
