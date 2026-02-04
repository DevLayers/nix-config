{ config, lib, pkgs, ... }:
{
  # Enable udisks2 for automatic partition detection
  services.udisks2 = {
    enable = true;

    # Mount options for NTFS filesystems
    settings = {
      "mount_options.conf" = {
        ntfs_defaults = {
          ntfs_defaults = "uid=1000,gid=100,umask=0022";
        };
      };
    };
  };

  # Enable GVFS for file manager integration
  services.gvfs = {
    enable = true;
    package = pkgs.gnome.gvfs;
  };

  # Polkit rules to allow users to mount/unmount filesystems
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if ((action.id == "org.freedesktop.udisks2.filesystem-mount-system" ||
           action.id == "org.freedesktop.udisks2.filesystem-mount") &&
          subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';
}