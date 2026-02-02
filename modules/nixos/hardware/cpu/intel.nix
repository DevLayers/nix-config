# Intel CPU Optimizations
{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf;
  dev = config.modules.device;
in
{
  imports = [
    ../../services/thermald.nix  # Intel thermal management
  ];

  config = mkIf (builtins.elem dev.cpu.type ["intel" "vm-intel"]) {
    # Intel CPU microcode updates for security and stability
    hardware.cpu.intel.updateMicrocode = true;

    boot = {
      # KVM virtualization support
      kernelModules = ["kvm-intel"];

      # Intel GPU optimizations
      # i915.fastboot=1: Skip unnecessary modesetting at boot (faster boot)
      # enable_gvt=1: Enable Intel GVT-g for GPU virtualization
      kernelParams = ["i915.fastboot=1" "enable_gvt=1"];

      # VMD (Volume Management Device) for NVMe RAID on Intel platforms
      initrd.availableKernelModules = ["vmd"];
    };

    # Intel GPU monitoring and debugging tools
    environment.systemPackages = with pkgs; [
      intel-gpu-tools  # intel_gpu_top, intel_gpu_time, etc.
    ];
  };
}
