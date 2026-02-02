{ ... }:
{
  # Install atuin via home-manager module
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      inline_height = 25;
      invert = true;
      records = true;
      search_mode = "skim";
      secrets_filter = true;
      style = "compact";
      enter_accept = true;
      # Disable auto-sync for better startup performance
      # Set to true if you want cloud sync
      auto_sync = false;
      sync_frequency = "0";
    };
    flags = [ "--disable-up-arrow" ];
  };
}
