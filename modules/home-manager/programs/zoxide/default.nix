{ ... }:
{
  # Zoxide - smarter cd command with directory jumping
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [
      "--cmd cd" # Replace 'cd' command with zoxide
    ];
  };
}
