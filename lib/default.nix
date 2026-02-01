# Production-grade library helpers
{ lib, system ? "nixos", ... }:
let
  dag = import ./dag.nix { inherit lib; };
  secrets = import ./secrets.nix { inherit lib; };
  systemd = import ./systemd.nix { inherit lib; };
  fs = import ./fs.nix;
  aliases = import ./aliases.nix;
  firewall = import ./firewall.nix { inherit lib dag; };
  xdg = import ./xdg.nix system;
in
{
  # DAG system for ordered configurations
  inherit (dag)
    entryBefore
    entryAfter
    entryBetween
    entryAnywhere
    topoSort
    dagOf;

  # Secret management
  inherit (secrets) mkAgenixSecret;

  # Systemd hardening
  inherit (systemd)
    hardenService
    mkGraphicalService
    mkHyprlandService;

  # Filesystem
  inherit (fs) mkBtrfs;

  # Common utilities
  inherit (aliases) sslTemplate common;

  # NFTables firewall builders
  inherit (firewall)
    mkTable
    mkRuleset
    mkIngressChain
    mkPrerouteChain
    mkInputChain
    mkForwardChain
    mkOutputChain
    mkPostrouteChain;

  # XDG environment management
  inherit (xdg)
    glEnv
    sysEnv
    npmrc
    pythonrc;
}
