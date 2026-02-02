# Logrotate - Professional log management with compression
{ config, lib, ... }:
{
  services.logrotate = {
    enable = true;

    settings = {
      # Global settings applied to all logs unless overridden
      global = {
        # Rotate weekly
        weekly = true;

        # Keep 4 weeks of backlogs
        rotate = 4;

        # Create new log files after rotation
        create = true;

        # Compress rotated logs with zstd (better than gzip)
        compress = true;
        compresscmd = "${lib.getBin config.systemd.package}/bin/zstd";
        compressoptions = "-19";
        compressext = ".zst";
        uncompresscmd = "${lib.getBin config.systemd.package}/bin/unzstd";

        # Don't rotate empty logs
        notifempty = true;

        # Don't fail if log is missing
        missingok = true;

        # Don't mail old logs
        nomail = true;
      };
    };
  };
}
