# Intel GPU Drivers and Hardware Acceleration
{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf;
  dev = config.modules.device;

  # Intel VAAPI driver with H.264 hybrid codec support
  # Enables hardware acceleration for YouTube and other H.264 content
  vaapiIntel = pkgs.intel-vaapi-driver.override {enableHybridCodec = true;};
in
{
  config = mkIf (builtins.elem dev.gpu.type ["intel" "hybrid-nv" "hybrid-amd"]) {
    # Load Intel i915 GPU kernel module early in boot
    boot.initrd.kernelModules = ["i915"];

    # Use modesetting driver (better performance than intel DDX driver)
    services.xserver.videoDrivers = ["modesetting"];

    # Hardware acceleration: OpenCL, VAAPI, VDPAU
    hardware.graphics = {
      extraPackages = with pkgs; [
        intel-compute-runtime  # OpenCL support for Intel GPUs
        intel-media-driver     # VAAPI for newer Intel GPUs (Broadwell+)
        vaapiIntel             # VAAPI for older Intel GPUs + H.264 hybrid codec
        libvdpau-va-gl         # VDPAU support via VAAPI
      ];

      # 32-bit support for Steam and Wine
      extraPackages32 = with pkgs.pkgsi686Linux; [
        intel-media-driver
        vaapiIntel
        libvdpau-va-gl
      ];
    };

    # Use VA-API for VDPAU (better than native VDPAU for Intel)
    environment.variables = mkIf (config.hardware.graphics.enable && dev.gpu.type != "hybrid-nv") {
      VDPAU_DRIVER = "va_gl";
    };
  };
}
