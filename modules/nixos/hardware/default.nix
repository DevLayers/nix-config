# Hardware Support - CPU/GPU/Power auto-configuration
{
  imports = [
    ./options.nix      # Hardware device options (CPU/GPU type detection)
    ./cpu/intel.nix    # Intel CPU optimizations + thermald
    ./cpu/amd.nix      # AMD CPU optimizations (P-State, Zenpower)
    ./gpu/intel.nix    # Intel GPU drivers & hardware acceleration
    ./gpu/amd.nix      # AMD GPU drivers & hardware acceleration (AMDVLK, ROCm)
    ./gpu/nvidia.nix   # NVIDIA GPU drivers
    ./auto-cpufreq.nix # Automatic CPU management (all systems)
    ./power.nix        # Laptop power management (battery, undervolt, upower)
  ];
}
