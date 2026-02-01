{
  config,
  pkgs,
  lib,
  ...
}: {
  config = {
    services.dbus.apparmor = "enabled";

    # apparmor configuration
    security.apparmor = {
      enable = true;
      enableCache = true;

      # kill process that are not confined but have apparmor profiles enabled
      killUnconfinedConfinables = true;
      packages = [
        pkgs.apparmor-profiles
        # custom chrome profile
        (pkgs.writeTextDir "etc/apparmor.d/bin.chrome" (builtins.readFile ./profiles/chrome))
      ];
    };

    environment.systemPackages = with pkgs; [
      apparmor-bin-utils
      apparmor-profiles
      apparmor-parser
      libapparmor
      apparmor-pam
      apparmor-utils
    ];
  };
}
