# System services - Production-grade performance & stability
{
  imports = [
    # Performance & hardware - ENABLED
    ./zram.nix          # ZRAM swap (90% memory compression - essential)
    ./thermald.nix      # Thermal management for Intel CPUs
    ./fwupd.nix         # Firmware updates via fwupd
    ./udisks2.nix       # Disk management and automounting

    # Time synchronization - using simpler timesyncd (change to ntpd.nix if you prefer)
    ./systemd/timesyncd.nix  # systemd-timesyncd (lightweight, sufficient for most)
    # ./ntpd.nix          # NTP daemon (more accurate, better for servers)

    # System stability - ENABLED
    ./systemd/oomd.nix  # Out-of-memory daemon (prevents system freeze)

    # Logging - ENABLED
    ./journald.nix      # Journal size limits (100MB max, 7 days retention)
    ./logrotate.nix     # Professional log rotation with zstd compression
  ];
}
