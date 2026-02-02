# Networking configuration - Core + Enhancements
{
  imports = [
    # Core networking (hardened SSH + firewall)
    ./ssh.nix           # Hardened SSH (port 30, modern crypto, fail2ban)
    ./firewall          # DAG-based NFTables with fail2ban

    # Privacy & security enhancements - ENABLED
    ./blocker.nix       # StevenBlack hosts blocker (ads, porn, fakenews, gambling)
    ./resolved.nix      # systemd-resolved with DNS-over-TLS
    ./network-manager.nix # NetworkManager with IPv6 + MAC randomization
    ./networking.nix    # Basic networking (hostId, nameservers)
  ];
}
