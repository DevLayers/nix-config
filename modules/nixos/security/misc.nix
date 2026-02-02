# Security Miscellaneous - Kicksecure hardening configurations
{ pkgs, lib, ... }:
let
  l = lib // builtins;

  # Kicksecure security-misc repository sources
  # These are production-tested hardening configurations from Kicksecure project
  sources = {
    issue = {
      user = "Kicksecure";
      repo = "security-misc";
      rev = "de6f3ea74a5a1408e4351c955ecb7010825364c5";
      file = "usr/lib/issue.d/20_security-misc.issue";
      sha256 = "00ilswn1661h8rwfrq4w3j945nr7dqd1g519d3ckfkm0dr49f26b";
    };

    gitconfig = {
      user = "Kicksecure";
      repo = "security-misc";
      rev = "de6f3ea74a5a1408e4351c955ecb7010825364c5";
      file = "etc/gitconfig";
      sha256 = "1p3adrbmv7fvy84v3i3m3xrzbc2zdrxzn6prac8f6418vwrdmyp7";
    };

    bluetooth = {
      user = "Kicksecure";
      repo = "security-misc";
      rev = "de6f3ea74a5a1408e4351c955ecb7010825364c5";
      file = "etc/bluetooth/30_security-misc.conf";
      sha256 = "0xyvvgmm0dhf0dfhfj4hdbyf2ma30bpd1m5zx6xnjdfvy2fr44na";
    };

    module-blacklist = {
      user = "Kicksecure";
      repo = "security-misc";
      rev = "de6f3ea74a5a1408e4351c955ecb7010825364c5";
      file = "etc/modprobe.d/30_security-misc_disable.conf";
      sha256 = "1mab9cnnwpc4a0x1f5n45yn4yhhdy1affdmmimmslg8rcw65ajh2";
    };
  };

  fetchGhFile = { user, repo, rev, file, sha256, ... }:
    builtins.fetchurl {
      url = "https://raw.githubusercontent.com/${user}/${repo}/${rev}/${file}";
      inherit sha256;
    };
in
{
  environment.etc = {
    # Empty /etc/securetty to prevent root login on tty.
    # This is a critical security measure - root should not be able to login
    # directly on any terminal. Use sudo/doas from a regular user instead.
    securetty.text = ''
      # /etc/securetty: list of terminals on which root is allowed to login.
      # See securetty(5) and login(1).
      # This file is intentionally empty for security reasons.
    '';

    # Borrow Kicksecure banner/issue.
    # Displays security warnings before login.
    issue.source = fetchGhFile sources.issue;

    # Borrow Kicksecure gitconfig, disabling git symlinks and enabling fsck
    # by default for better git security.
    # - Disables symlinks (prevents directory traversal attacks)
    # - Enables fsck (detects repository corruption)
    gitconfig.source = fetchGhFile sources.gitconfig;

    # Borrow Kicksecure bluetooth configuration for better bluetooth privacy
    # and security. Disables bluetooth automatically when not connected to
    # any device (saves power and reduces attack surface).
    "bluetooth/main.conf".source = l.mkForce (fetchGhFile sources.bluetooth);

    # Borrow Kicksecure and secureblue module blacklist.
    # "install "foobar" /bin/not-existent" prevents the module from being
    # loaded at all. "blacklist "foobar"" prevents the module from being
    # loaded automatically at boot, but it can still be loaded afterwards.
    # This blacklists unnecessary/insecure kernel modules.
    "modprobe.d/nm-module-blacklist.conf".source = fetchGhFile sources.module-blacklist;
  };

  # Don't store coredumps from systemd-coredump.
  # Coredumps can contain sensitive information (passwords, keys, etc.)
  # and consume disk space unnecessarily.
  systemd.coredump.extraConfig = l.mkDefault ''
    Storage=none
  '';

  systemd.tmpfiles.settings = {
    # Restrict permissions of /home/$USER so that only the owner of the
    # directory can access it (the user). systemd-tmpfiles also has the benefit
    # of recursively setting permissions too, with the "Z" option as seen below.
    # This prevents other users from reading your home directory.
    "restricthome"."/home/*".Z.mode = "0700";

    # Make all files in /etc/nixos owned by root, and only readable by root.
    # /etc/nixos is not owned by root by default, and configuration files can
    # on occasion end up also not owned by root. This can be hazardous as files
    # that are included in the rebuild may be editable by unprivileged users,
    # so this mitigates that.
    "restrictetcnixos"."/etc/nixos/*".Z = {
      mode = "0000";
      user = "root";
      group = "root";
    };
  };
}
