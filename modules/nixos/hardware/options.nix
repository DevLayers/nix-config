# Hardware Device Options - CPU/GPU type detection and configuration
{ config, lib, ... }:
let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) nullOr listOf enum str;
in
{
  options.modules.device = {
    type = mkOption {
      type = enum [ "laptop" "desktop" "server" "hybrid" "lite" "vm" ];
      default = "desktop";
      description = ''
        The type/purpose of the device that will be used within the rest of the configuration.
          - laptop: portable devices with battery optimizations
          - desktop: stationary devices configured for maximum performance
          - server: server and infrastructure
          - hybrid: provide both desktop and server functionality
          - lite: a lite device, such as a raspberry pi
          - vm: a virtual machine
      '';
    };

    # CPU configuration
    cpu = {
      type = mkOption {
        type = nullOr (enum [ "pi" "intel" "vm-intel" "amd" "vm-amd" ]);
        default = null;
        description = ''
          The manufacturer/type of the primary system CPU.

          Determines which microcode services will be enabled and provides
          additional kernel packages and optimizations.
        '';
      };

      amd = {
        pstate.enable = mkEnableOption "AMD P-State Driver (modern CPU frequency scaling)";
        zenpower = {
          enable = mkEnableOption "AMD Zenpower Driver (CPU voltage/frequency monitoring and undervolting)";
          args = mkOption {
            type = str;
            default = "-p 0 -v 3C -f A0"; # Pstate 0, 1.175V voltage, 4000MHz clock
            description = ''
              Zenpower/Zenstates arguments for CPU undervolting.

              Format: -p <pstate> -v <voltage_hex> -f <freq_hex>
              Example: "-p 0 -v 3C -f A0" = P-state 0, 1.175V, 4.0GHz

              This reduces power consumption and heat generation on AMD CPUs.
              Adjust carefully - too low voltage causes instability.
            '';
          };
        };
      };
    };

    # GPU configuration
    gpu = {
      type = mkOption {
        type = nullOr (enum [ "pi" "amd" "intel" "nvidia" "hybrid-nv" "hybrid-amd" ]);
        default = null;
        description = ''
          The manufacturer/type of the primary system GPU.

          Determines which GPU drivers are loaded for optimal video output
          and hardware acceleration (VAAPI, OpenCL, CUDA).

          - intel: Intel integrated graphics
          - amd: AMD discrete or integrated graphics
          - nvidia: NVIDIA discrete graphics
          - hybrid-nv: Intel + NVIDIA (laptop with NVIDIA dGPU)
          - hybrid-amd: Intel + AMD (laptop with AMD dGPU)
        '';
      };
    };

    monitors = mkOption {
      type = listOf str;
      default = [ ];
      description = ''
        A list of monitors connected to the system.

        This does not affect drivers - it's only for declaring monitors
        in window manager configurations, wallpapers, and workspace layouts.

        Monitors should be listed from left to right in physical placement order.
      '';
    };
  };
}
