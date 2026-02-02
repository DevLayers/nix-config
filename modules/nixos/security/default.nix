# Production-grade security hardening modules
# All security hardening enabled by default for maximum protection
{
  imports = [
    ./kernel.nix      # 80+ sysctl hardening, kernel params, module blacklist
    ./auditd.nix      # System auditing with auto-cleanup
    ./network.nix     # MAC randomization, IPv6 privacy
    ./pam.nix         # 65536-round SHA512 hashing
    ./sudo.nix        # Secure NOPASSWD whitelist
    ./coredump.nix    # Disable core dumps
    ./apparmor        # AppArmor MAC with Chrome profile
    ./misc.nix        # Kicksecure hardening (securetty, git, bluetooth, permissions)
  ];
}
