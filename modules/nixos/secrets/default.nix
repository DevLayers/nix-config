# Agenix secrets management
# Add your secrets here using mkAgenixSecret helper from lib
{ config, lib, ... }:
{
  # Configure agenix
  age.identityPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
  ];

  # Example secret configuration (uncomment and customize as needed):
  # age.secrets.example = lib.mkAgenixSecret config.services.example.enable {
  #   file = "example.age";
  #   owner = "example-user";
  #   group = "example-group";
  #   mode = "440";
  # };
}
