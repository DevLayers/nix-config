# AMD CPU Optimizations
{ config, pkgs, lib, ... }:
let
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.strings) versionOlder versionAtLeast;
  dev = config.modules.device;

  kver = config.boot.kernelPackages.kernel.version;
  inherit (dev.cpu.amd) pstate zenpower;
in
{
  config = mkIf (builtins.elem dev.cpu.type ["amd" "vm-amd"]) {
    # AMD CPU monitoring and control tools
    environment.systemPackages = [pkgs.amdctl];

    # AMD CPU microcode updates for security and stability
    hardware.cpu.amd.updateMicrocode = true;

    boot = mkMerge [
      {
        # KVM virtualization support for AMD CPUs
        # amd_iommu=on: Enable IOMMU for device passthrough
        # Note: Add "iommu=pt" kernel param to reduce IOMMU overhead if needed
        kernelModules = ["kvm-amd"];
        kernelParams = ["amd_iommu=on"];
      }

      {
        # AMD-specific kernel modules
        kernelModules = [
          "amd-pstate"  # Modern AMD CPU frequency scaling (kernel 5.17+)
          "zenpower"    # Read CPU voltage, current, power (better than k10temp)
          "msr"         # x86 CPU MSR (Model-Specific Register) access
        ];

        # Zenpower kernel module (not in mainline)
        extraModulePackages = [config.boot.kernelPackages.zenpower];
      }

      # AMD P-State driver configuration (kernel version specific)
      # P-State provides better performance and power efficiency than acpi-cpufreq

      # Kernel 5.17 - 6.0: Blacklist old acpi-cpufreq driver
      (mkIf (pstate.enable && (versionAtLeast kver "5.17") && (versionOlder kver "6.1")) {
        kernelParams = ["initcall_blacklist=acpi_cpufreq_init"];
        kernelModules = ["amd-pstate"];
      })

      # Kernel 6.1 - 6.2: Use passive mode
      (mkIf (pstate.enable && (versionAtLeast kver "6.1") && (versionOlder kver "6.3")) {
        kernelParams = ["amd_pstate=passive"];
      })

      # Kernel 6.3+: Use active mode (best performance)
      (mkIf (pstate.enable && (versionAtLeast kver "6.3")) {
        kernelParams = ["amd_pstate=active"];
      })
    ];

    # Ryzen CPU undervolting service (reduces heat and power consumption)
    # Uses zenstates to apply voltage/frequency curves
    systemd.services.zenstates = mkIf zenpower.enable {
      enable = true;
      description = "AMD Ryzen CPU Undervolting via Zenstates";
      after = ["syslog.target" "systemd-modules-load.service"];

      unitConfig = {
        ConditionPathExists = "${pkgs.zenstates}/bin/zenstates";
      };

      serviceConfig = {
        Type = "oneshot";
        User = "root";
        ExecStart = "${pkgs.zenstates}/bin/zenstates ${zenpower.args}";
        RemainAfterExit = true;
      };

      wantedBy = ["multi-user.target"];
    };
  };
}
