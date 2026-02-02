# Systemd service hardening helpers
{ lib }:
with lib;
{
  # Apply comprehensive systemd hardening to a service
  # Usage: systemd.services.myservice = hardenService { ExecStart = "..."; }
  hardenService = attrs:
    attrs // (mapAttrs (_: mkOptionDefault) {
      # Capabilities
      AmbientCapabilities = "";
      CapabilityBoundingSet = "";

      # Security
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;

      # Filesystem
      PrivateDevices = true;
      PrivateMounts = true;
      PrivateTmp = true;
      PrivateUsers = true;

      # Process
      ProcSubset = "pid";
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      ProtectSystem = "strict";

      # IPC
      RemoveIPC = true;

      # System calls
      RestrictAddressFamilies = ["AF_UNIX" "AF_INET" "AF_INET6"];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
      SystemCallErrorNumber = "EPERM";
      SystemCallFilter = [
        "@system-service"
        "~@clock"
        "~@cpu-emulation"
        "~@debug"
        "~@module"
        "~@mount"
        "~@obsolete"
        "~@privileged"
        "~@raw-io"
        "~@reboot"
        "~@swap"
      ];
    });

  # Create a graphical session service
  mkGraphicalService = recursiveUpdate {
    Unit = {
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target"];
    };
    Install.WantedBy = ["graphical-session.target"];
  };

  # Create a Hyprland-specific service
  mkHyprlandService = recursiveUpdate {
    Unit = {
      PartOf = ["hyprland-session.target"];
      After = ["hyprland-session.target"];
    };
    Install.WantedBy = ["hyprland-session.target"];
  };
}
