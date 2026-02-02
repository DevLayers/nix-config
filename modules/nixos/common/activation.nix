# System Activation Scripts - Run during nixos-rebuild
{ pkgs, lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.modules.system.activation = {
    diffGenerations = mkEnableOption "Show diff between system generations on rebuild";
  };

  config = {
    system.activationScripts = {
      # Show what changed between the old and new system
      # Runs during nixos-rebuild switch/boot
      diff = mkIf config.modules.system.activation.diffGenerations {
        supportsDryActivation = true;
        text = ''
          if [[ -e /run/current-system ]]; then
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "System Changes (nvd diff):"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            ${pkgs.nvd}/bin/nvd diff /run/current-system "$systemConfig" || true
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
          fi
        '';
      };
    };
  };
}
