# Production-grade Nix daemon optimization and configuration
{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (builtins) elem;
  inherit (lib.trivial) pipe;
  inherit (lib.types) isType;
  inherit (lib.attrsets) mapAttrsToList filterAttrs mapAttrs;
in {
  nix = let
    mappedRegistry = pipe inputs [
      (filterAttrs (_: isType "flake"))
      (mapAttrs (_: flake: {inherit flake;}))
      (flakes: flakes // {nixpkgs.flake = inputs.nixpkgs;})
    ];
  in {
    # Pin the registry to avoid downloading and evaluating
    # a new nixpkgs version on each command causing a re-eval.
    registry = mappedRegistry // {default-flake = mappedRegistry.nixpkgs;};

    # Make legacy nix commands consistent with flake
    nixPath = mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;

    # Run Nix daemon on lowest priority for system responsiveness
    daemonCPUSchedPolicy = "batch";
    daemonIOSchedClass = "idle";
    daemonIOSchedPriority = 7;

    # Automatic garbage collection weekly
    gc = {
      automatic = true;
      dates = "Sat *-*-* 03:00";
      options = "--delete-older-than 10d";
    };

    # Automatic store optimization
    optimise = {
      automatic = true;
      dates = ["04:00"];
    };

    # Disable channels, we use flakes
    channel.enable = false;

    settings = {
      # Use XDG base directories
      use-xdg-base-directories = true;

      # Free up to 10GiB when less than 5GB left
      min-free = "${toString (5 * 1024 * 1024 * 1024)}";
      max-free = "${toString (10 * 1024 * 1024 * 1024)}";

      # Automatically optimize store
      auto-optimise-store = true;

      # User permissions - restrict nix commands to wheel group (sudoers only)
      allowed-users = lib.mkForce ["@wheel"];
      trusted-users = ["root" "@wheel"];

      # Build settings
      max-jobs = "auto";
      sandbox = true;
      sandbox-fallback = false;
      system-features = ["nixos-test" "kvm" "recursive-nix" "big-parallel"];

      # Build behavior
      keep-going = true;
      connect-timeout = 5;
      log-lines = 30;

      # Experimental features
      extra-experimental-features = [
        "flakes"
        "nix-command"
        "recursive-nix"
        "ca-derivations"
        "auto-allocate-uids"
        "cgroups"
      ];

      # Configuration
      warn-dirty = false;
      http-connections = 50;
      accept-flake-config = false;
      use-cgroups = true;

      # For direnv GC roots
      keep-derivations = true;
      keep-outputs = true;

      # Binary caches
      builders-use-substitutes = true;

      # Extensive binary cache list for faster builds
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
        "https://anyrun.cachix.org"
        "https://cache.garnix.io"
        "https://ags.cachix.org"
        "https://cache.privatevoid.net"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "ags.cachix.org-1:naAvMrz0CuYqeyGNyLgE010iUiuf/qx6kYrUv3NwAJ8="
      ];
    };
  };
}
