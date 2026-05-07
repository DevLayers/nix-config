{lib, ...}:{
  # Don't store coredumps from systemd-coredump.
  systemd.coredump.settings.Coredump.Storage = lib.mkDefault "none";
}