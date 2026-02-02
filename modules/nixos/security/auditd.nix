{
  config,
  lib,
  ...
}: {
  config = {
    security.audit.enable = false; # disable auditd entirely
    security.auditd.enable = false;

    # Optional: keep the cleanup timer for other logs if desired
    systemd.timers."clean-audit-log" = {
      description = "Clean old logs daily";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };
    };
  };
}
