{ config, pkgs, ... }:
{
  # Keychain manages SSH keys and GPG keys, keeping them loaded across sessions
  # It's a frontend for ssh-agent that maintains long-running agents
  programs.keychain = {
    enable = true;

    # SSH keys to automatically load
    # Add your GitHub SSH key path here (e.g., "id_ed25519", "id_rsa")
    keys = [ "id_ed25519" ];

    # Inherit the environment from the keychain agent
    # This ensures SSH_AUTH_SOCK and other vars are set correctly
    enableZshIntegration = true;

    # Additional keychain options
    extraFlags = [
      "--quiet"              # Less verbose output
      "--absolute"           # Use absolute paths
      "--dir" "$HOME/.keychain"  # Keychain directory
    ];
  };

  # Set SSH_ASKPASS to use GNOME Keyring's askpass
  home.sessionVariables = {
    SSH_ASKPASS = "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
  };
}
