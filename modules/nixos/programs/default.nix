# Programs - System-wide program configurations
{
  imports = [
    ./bash.nix    # Fallback shell (if switching from zsh)
    ./direnv.nix  # Automatic development environment integration
    ./nano.nix    # Fallback editor (emergency recovery, quick edits)
  ];
}
