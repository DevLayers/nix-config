{ inputs, ... }:
{
  # When applied, the stable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.stable'
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };

  # Add zen-browser from the flake input
  zen-browser-overlay = final: _prev: {
    zen-browser = inputs.zen-browser.packages.${final.stdenv.hostPlatform.system}.default;
  };
}
