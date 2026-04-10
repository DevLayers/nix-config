{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.modules.services.localsend;
in
{
  options.modules.services.localsend.enable = lib.mkEnableOption "LocalSend discovery support";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.localsend ];

    # LocalSend relies on mDNS/Avahi for peer discovery.
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };

    # Keep standard firewall ports declared for compatibility with non-custom firewall backends.
    networking.firewall.allowedTCPPorts = [ 53317 ];
    networking.firewall.allowedUDPPorts = [ 53317 ];
  };
}
