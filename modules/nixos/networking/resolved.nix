{
  services.resolved = {
    enable = true;

    settings = {
      Resolve = {
        # Primary Quad9 servers
        DNS = [
          "9.9.9.9"          # Quad9 IPv4
          "149.112.112.112"  # Quad9 secondary IPv4
          "2620:fe::fe"      # Quad9 IPv6
          "2620:fe::9"       # Quad9 secondary IPv6
        ];

        # Fallback DNS (Cloudflare)
        FallbackDNS = [
          "1.1.1.1"
          "1.0.0.1"
          "2606:4700:4700::1111"
          "2606:4700:4700::1001"
        ];

        # Global resolution
        Domains = ["~."];

        # Security
        DNSSEC = "allow-downgrade";
        DNSOverTLS = "yes";

        # Optional: enable caching for faster repeated lookups
        Cache = "yes";
      };
    };
  };
}