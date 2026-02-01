# Filesystem helpers
{
  # Add standard BTRFS mount options for performance and reliability
  # Usage: fileSystems."/".options = mkBtrfs ["subvol=@"];
  mkBtrfs = list: list ++ ["compress=zstd" "noatime"];
}
