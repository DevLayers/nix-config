{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkRuleset mkOption mkInputChain mkOutputChain mkForwardChain mkPrerouteChain mkPostrouteChain mkEnableOption topoSort;
  inherit (lib.types) attrsOf submodule listOf str;
  inherit (lib.strings) optionalString concatMapStringsSep concatStringsSep;
  inherit (lib.attrsets) attrNames filterAttrs mapAttrsToList;
  inherit (lib.lists) concatLists;
  inherit (builtins) length head;

  sys = config.modules.system;
  cfg = config.networking.nftables;

  check-results =
    pkgs.runCommand "check-nft-ruleset" {
      nativeBuildInputs = [pkgs.nftables];
      ruleset = pkgs.writeText "nft-ruleset" cfg.ruleset;
    } ''
      mkdir -p $out

      # Validate nftables ruleset
      nft -c -f $ruleset 2>&1 > $out/message \
        && echo false > $out/assertion \
        || echo true > $out/assertion
    '';
in {
  imports = [./rules.nix];
  
  options = {
    networking.nftables.rules = mkOption {
      default = {};
      description = "NFTables rules using DAG-based configuration";
      type = attrsOf (submodule ({config, ...}: {
        options = {
          enable = mkEnableOption "table";
          filter = mkOption {
            default = {};
            description = "Filter table chains";
            type = submodule {
              options = {
                input = mkInputChain;
                output = mkOutputChain;
                forward = mkForwardChain;
                prerouting = mkPrerouteChain;
                postrouting = mkPostrouteChain;
              };
            };
          };
          nat = mkOption {
            default = {};
            description = "NAT table chains";
            type = submodule {
              options = {
                input = mkInputChain;
                output = mkOutputChain;
                forward = mkForwardChain;
                prerouting = mkPrerouteChain;
                postrouting = mkPostrouteChain;
              };
            };
          };
          route = mkOption {
            default = {};
            description = "Route table chains";
            type = submodule {
              options = {
                input = mkInputChain;
                output = mkOutputChain;
                forward = mkForwardChain;
                prerouting = mkPrerouteChain;
                postrouting = mkPostrouteChain;
              };
            };
          };
        };
        
        config = let
          buildChainDag = chain:
            concatMapStringsSep "\n" ({
              name,
              data,
            }: let
              protocol =
                if data.protocol == null
                then ""
                else data.protocol;
              field =
                if data.field == null
                then ""
                else data.field;
              inherit (data) policy;
              values = map toString data.value;
              value =
                if data.value == null
                then ""
                else
                  (
                    if length data.value == 1
                    then head values
                    else "{ ${concatStringsSep ", " values} }"
                  );
            in ''
              ${protocol} ${field} ${value} ${policy} comment ${name}
            '') ((topoSort chain).result or (throw "Cycle in DAG"));

          buildChain = chainType: chain:
            mapAttrsToList (chainName: chainDag: ''
              chain ${chainName} {
                type ${chainType} hook ${chainName} priority 0;

                ${buildChainDag chainDag}
              }
            '') (filterAttrs (_: g: length (attrNames g) > 0) chain);
        in {
          objects = let
            chains = concatLists [
              (
                if config ? filter
                then buildChain "filter" config.filter
                else []
              )
              (
                if config ? nat
                then buildChain "nat" config.nat
                else []
              )
              (
                if config ? route
                then buildChain "route" config.route
                else []
              )
            ];
          in
            chains;
        };
      }));
    };
  };
  
  config = {
    networking.nftables = {
      enable = true;

      # flush ruleset on each reload
      flushRuleset = true;

      # nftables.tables is semi-verbatim configuration
      # that is inserted **before** nftables.ruleset
      # as per the nftables module.
      tables = {
        "fail2ban" = {
          name = "fail2ban-nftables";
          family = "ip";
          content = ''
            # <https://wiki.gbe0.com/en/linux/firewalling-and-filtering/nftables/fail2ban>
            chain input {
              type filter hook input priority 100;
            }
          '';
        };
      };

      # Our ruleset, built with our local ruleset builder from lib/network/firewall.nix
      # I prefer using this to the nftables.tables.* and verbatim nftables.ruleset = ""
      # kinds of configs, as it allows me to programmatically approach to my ruleset
      # instead of structuring it inside a multiline string. nftables.rules, which is
      # located in ./rules.nix, is easily parsable and modifiable with the help of Nix.
      ruleset = mkRuleset cfg.rules;
    };

    assertions = [
      {
        assertion = import "${check-results}/assertion";
        message = ''
          Bad config:
          ${builtins.readFile "${check-results}/message"}
        '';
      }
    ];

    # Pin IFD used in nftables assertion as a system dependency.
    # Ideally this should use either system.checks or extraDependencies
    # however, the former doesn't include the check in the system closure
    # so it is preferable.
    system.checks = [check-results];
  };
}
