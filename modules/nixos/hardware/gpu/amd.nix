# AMD GPU Drivers and Hardware Acceleration
{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf;
  dev = config.modules.device;
in
{
  config = mkIf (builtins.elem dev.gpu.type ["amd" "hybrid-amd"]) {
    # AMD GPU drivers (modesetting + amdgpu)
    services.xserver.videoDrivers = lib.mkDefault ["modesetting" "amdgpu"];

    # Load AMD GPU kernel module early
    boot = {
      initrd.kernelModules = ["amdgpu"];  # Load in initrd for early KMS
      kernelModules = ["amdgpu"];         # Fallback if initrd load fails
    };

    # AMD GPU monitoring tool
    environment.systemPackages = [pkgs.nvtopPackages.amd];

    # Hardware acceleration: AMDVLK, Mesa, Vulkan, OpenCL (ROCm)
    hardware.graphics = {
      extraPackages = with pkgs;
        [
          # AMD Vulkan driver (AMDVLK - official AMD driver)
          amdvlk

          # Mesa (open-source AMD driver with RADV Vulkan)
          mesa

          # Vulkan tools and validation
          vulkan-tools
          vulkan-loader
          vulkan-validation-layers
          vulkan-extension-layer
        ]
        ++ (
          # ROCm OpenCL support (backwards compatible for older nixpkgs)
          if pkgs ? rocmPackages.clr
          then with pkgs.rocmPackages; [clr clr.icd]
          else with pkgs; [rocm-opencl-icd rocm-opencl-runtime]
        );

      # 32-bit support for Steam and Wine
      extraPackages32 = [pkgs.driversi686Linux.amdvlk];
    };
  };
}
