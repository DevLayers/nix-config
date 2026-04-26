{
  services.resolved = {
    enable = true;

    settings = {
      Resolve = {
        # Keep resolved enabled, but let NetworkManager manage
        # active-connection DNS servers (required for DNS switchers).
        DNSSEC = "allow-downgrade";
        DNSOverTLS = "opportunistic";

        # Optional: enable caching for faster repeated lookups
        Cache = "yes";
      };
    };
  };
}