# Agenix secret management helpers
{ lib, ... }:
{
  # Create an agenix secret with conditional enablement
  # Usage: mkAgenixSecret config.services.foo.enable { file = "foo.age"; owner = "foo"; }
  mkAgenixSecret = enableCondition: { file, owner ? "root", group ? "root", mode ? "400" }:
    lib.mkIf enableCondition {
      file = ../secrets/${file};
      inherit owner group mode;
    };
}
