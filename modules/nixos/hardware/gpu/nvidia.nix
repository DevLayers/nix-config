# NVIDIA GPU Drivers and Configuration
{ config, pkgs, lib, ... }:
let
  inherit (lib) mkIf mkDefault mkMerge;
  dev = config.modules.device;
in
{
  config = mkIf (builtins.elem dev.gpu.type ["nvidia" "hybrid-nv"]) {
    # NVIDIA drivers require unfree packages
    nixpkgs.config.allowUnfree = true;

    # Blacklist nouveau (open-source NVIDIA driver - poor performance)
    # Prevents conflicts with proprietary NVIDIA driver
    boot.blacklistedKernelModules = ["nouveau"];

    environment = {
      # Environment variables for NVIDIA
      sessionVariables = mkMerge [
        {
          LIBVA_DRIVER_NAME = "nvidia";  # Use NVIDIA for VA-API
          # Disable hardware cursors on Wayland (prevents cursor artifacts)
          WLR_NO_HARDWARE_CURSORS = "1";
        }
      ];

      systemPackages = with pkgs; [
        nvtopPackages.nvidia  # GPU monitoring tool

        # Vulkan support
        mesa
        vulkan-tools
        vulkan-loader
        vulkan-validation-layers
        vulkan-extension-layer

        # VA-API support
        libva
        libva-utils
      ];
    };

    hardware = {
      nvidia = {
        # Use production driver (most stable)
        package = mkDefault config.boot.kernelPackages.nvidiaPackages.production;

        # Enable modesetting (required for Wayland)
        modesetting.enable = mkDefault true;

        # NVIDIA Optimus (hybrid graphics) configuration
        prime.offload = let
          isHybrid = dev.gpu.type == "hybrid-nv";
        in {
          enable = isHybrid;
          enableOffloadCmd = isHybrid;  # Provides nvidia-offload command
        };

        # Power management
        powerManagement = {
          enable = mkDefault true;
          finegrained = mkDefault true;  # Fine-grained power management for laptops
        };

        # Use open-source NVIDIA kernel modules (for RTX 20/30/40 series)
        # Older GPUs should set this to false in host config
        open = mkDefault true;

        # NVIDIA settings GUI and persistence daemon
        nvidiaSettings = true;
        nvidiaPersistenced = true;

        # Force full composition pipeline (reduces tearing)
        forceFullCompositionPipeline = true;
      };

      # Hardware acceleration via VA-API
      graphics = {
        extraPackages = with pkgs; [nvidia-vaapi-driver];
        extraPackages32 = with pkgs.pkgsi686Linux; [nvidia-vaapi-driver];
      };
    };

    # Load NVIDIA modules
    services.xserver.videoDrivers = ["nvidia"];
  };
}
