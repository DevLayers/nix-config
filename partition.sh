#!/usr/bin/env bash
# NixOS Automated Installer with LUKS + BTRFS
# WARNING: This will ERASE /dev/nvme0n1!

set -euo pipefail

# Configuration
DISK="/dev/nvme0n1"
HOSTNAME="energy"
USERNAME="yourname"  # CHANGE THIS!

echo "⚠️  WARNING: This will ERASE $DISK"
echo "Press Ctrl+C now to abort, or Enter to continue..."
read

# 1. Partition the disk
echo "📦 Creating partitions..."
sgdisk --zap-all "$DISK"

# EFI partition – 1 GB
sgdisk -n 1:0:+1000M   -t 1:ef00 -c 1:"EFI"        "$DISK"

# Swap – 8 GB
sgdisk -n 2:0:+8000M   -t 2:8200 -c 2:"Swap"       "$DISK"

# Windows partitions
sgdisk -n 3:0:+102000M -t 3:0700 -c 3:"Windows-C" "$DISK"
sgdisk -n 4:0:+101000M -t 4:0700 -c 4:"Windows-D" "$DISK"
sgdisk -n 5:0:+100000M -t 5:0700 -c 5:"Windows-E" "$DISK"

# NixOS – ~199.9 GB (safe to fit GPT metadata)
sgdisk -n 6:0:+199900M -t 6:8300 -c 6:"NixOS"     "$DISK"

sleep 2
partprobe "$DISK"

# 2. Format partitions
echo "💾 Formatting partitions..."
mkfs.vfat -F 32 -n EFI "${DISK}p1"
mkswap -L swap "${DISK}p2"
swapon "${DISK}p2"
mkfs.ntfs -f -L "Windows-C" "${DISK}p3"
mkfs.ntfs -f -L "Windows-D" "${DISK}p4"
mkfs.ntfs -f -L "Windows-E" "${DISK}p5"

# 3. LUKS encryption
echo "🔒 Setting up LUKS encryption..."
echo "Enter your LUKS passphrase (you'll need this at every boot!):"
cryptsetup luksFormat --type luks2 \
  --cipher aes-xts-plain64 \
  --key-size 512 \
  --hash sha512 \
  --pbkdf argon2id \
  --iter-time 5000 \
  "${DISK}p6"

echo "Opening encrypted partition..."
cryptsetup open "${DISK}p6" enc

# 4. Create BTRFS filesystem and subvolumes
echo "🌳 Creating BTRFS filesystem..."
mkfs.btrfs -L nixos /dev/mapper/enc

mount /dev/mapper/enc /mnt
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/persist
btrfs subvolume create /mnt/log
btrfs subvolume create /mnt/snapshots
umount /mnt

# 5. Mount filesystems
echo "📂 Mounting filesystems..."
mount -o subvol=root,compress=zstd,noatime /dev/mapper/enc /mnt
mkdir -p /mnt/{nix,home,persist,var/log,snapshots,boot}
mount -o subvol=nix,compress=zstd,noatime /dev/mapper/enc /mnt/nix
mount -o subvol=home,compress=zstd,noatime /dev/mapper/enc /mnt/home
mount -o subvol=persist,compress=zstd,noatime /dev/mapper/enc /mnt/persist
mount -o subvol=log,compress=zstd,noatime /dev/mapper/enc /mnt/var/log
mount -o subvol=snapshots,compress=zstd,noatime /dev/mapper/enc /mnt/snapshots
mount "${DISK}p1" /mnt/boot

# 6. Generate configuration
echo "⚙️  Generating NixOS configuration..."
nixos-generate-config --root /mnt

# 7. Create minimal configuration
cat > /mnt/etc/nixos/configuration.nix <<'EOF'
{ config, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "energy";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    gnome-photos gnome-tour gnome-music epiphany geary totem
  ];

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.REPLACEME = {
    isNormalUser = true;
    description = "User";
    extraGroups = [ "wheel" "networkmanager" ];
    packages = with pkgs; [ firefox git vim ];
  };

  security.sudo.wheelNeedsPassword = true;
  environment.systemPackages = with pkgs; [ wget curl git vim htop ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "24.11";
}
EOF

# Replace username
sed -i "s/REPLACEME/$USERNAME/g" /mnt/etc/nixos/configuration.nix

echo "✅ Configuration created!"
echo ""
echo "📋 Please verify /mnt/etc/nixos/hardware-configuration.nix contains:"
echo "  - All 6 BTRFS subvolumes (root, nix, home, persist, log, snapshots)"
echo "  - compress=zstd,noatime options on all"
echo "  - neededForBoot = true on persist, log, snapshots"
cat /mnt/etc/nixos/hardware-configuration.nix

echo ""
echo "Press Enter to continue with installation or Ctrl+C to abort..."
read

# 8. Install NixOS
echo "🚀 Installing NixOS..."
nixos-install

echo ""
echo "🎉 Installation complete!"
echo ""
echo "To set user password before rebooting:"
echo "  nixos-enter --root /mnt -c 'passwd $USERNAME'"
echo ""
echo "Then reboot with:"
echo "  umount -R /mnt && cryptsetup close enc && reboot"