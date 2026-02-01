# Systemd Journald - Prevent logs from consuming excessive disk space
{
  services.journald = {
    extraConfig = ''
      # Limit total journal size to 100MB (compressed)
      SystemMaxUse=100M

      # Keep only 7 days of logs
      MaxRetentionSec=7d

      # Compress logs for efficiency
      Compress=yes

      # Forward to wall only for critical messages
      ForwardToWall=no
    '';
  };
}
