# NixOS Installation Guide - Copy-Paste Ready Commands

Complete installation guide for dual-boot NixOS with LUKS + BTRFS.

## ⚠️ WARNING

- **Back up your data** before proceeding
- These commands will **ERASE YOUR ENTIRE DISK**
- Double-check device names before running commands
- **SAVE YOUR LUKS PASSPHRASE** - you cannot boot without it!

---

## 📋 Disk Layout (512GB NVMe)

```
/dev/nvme0n1           512GB Total
├─nvme0n1p1            1GB      EFI System Partition (FAT32)
├─nvme0n1p2            8GB      Linux Swap
├─nvme0n1p3            102GB    Windows C: (NTFS)
├─nvme0n1p4            101GB    Windows D: (NTFS)
├─nvme0n1p5            100GB    Windows E: (NTFS)
└─nvme0n1p6            200GB    LUKS2 Encrypted Container
  └─/dev/mapper/enc    200GB    BTRFS Filesystem
    ├─ root            /        (compress=zstd, noatime)
    ├─ nix             /nix     (compress=zstd, noatime)
    ├─ home            /home    (compress=zstd, noatime)
    ├─ persist         /persist (compress=zstd, noatime, neededForBoot)
    ├─ log             /var/log (compress=zstd, noatime, neededForBoot)
    └─ snapshots       /snapshots (compress=zstd, noatime, neededForBoot)
```

---

## 🚀 Installation Steps

### Step 1: Boot NixOS Installation Media

1. Download NixOS ISO from https://nixos.org/download
2. Create bootable USB with `dd` or Rufus/Etcher
3. Boot from USB (press F12/F2/DEL during boot)
4. Connect to WiFi if needed: `sudo systemctl start wpa_supplicant`

---

### Step 2: Identify Your Disk

```bash
# List all disks
lsblk

# Verify it's the correct disk (should show 512GB)
lsblk -o NAME,SIZE,TYPE /dev/nvme0n1
```

**⚠️ VERIFY**: Make sure `/dev/nvme0n1` is your 512GB NVMe drive before continuing!

---

### Step 3: Partition the Disk

**Copy-paste this entire block:**

```bash
# Start gdisk partitioning tool
gdisk /dev/nvme0n1
```

**Then type these commands one by one in gdisk:**

```
o
y
n
1

+1G
ef00
n
2

+8G
8200
n
3

+102G
0700
n
4

+101G
0700
n
5

+100G
0700
n
6


8300
w
y
```

**Verify partitions created:**

```bash
lsblk /dev/nvme0n1
```

You should see 6 partitions listed.

---

### Step 4: Format Partitions

**Copy-paste each command:**

```bash
# Format EFI partition
mkfs.vfat -F 32 -n EFI /dev/nvme0n1p1

# Setup swap
mkswap -L swap /dev/nvme0n1p2
swapon /dev/nvme0n1p2

# Format Windows partitions
mkfs.ntfs -f -L "Windows-C" /dev/nvme0n1p3
mkfs.ntfs -f -L "Windows-D" /dev/nvme0n1p4
mkfs.ntfs -f -L "Windows-E" /dev/nvme0n1p5
```

---

### Step 5: Setup LUKS2 Encryption

**Copy-paste this command:**

```bash
cryptsetup luksFormat --type luks2 --cipher aes-xts-plain64 --key-size 512 --hash sha512 --pbkdf argon2id --iter-time 5000 /dev/nvme0n1p6
```

**⚠️ IMPORTANT:**

- Type `YES` (in uppercase) to confirm
- Enter a **strong passphrase** (you'll need this at EVERY boot)
- **WRITE DOWN THIS PASSPHRASE** - if you forget it, your data is gone forever!

**Open the encrypted partition:**

```bash
cryptsetup open /dev/nvme0n1p6 enc
```

Enter your passphrase when prompted.

**Verify it's open:**

```bash
ls -l /dev/mapper/enc
```

Should show the encrypted device.

---

### Step 6: Create BTRFS Filesystem and Subvolumes

**Copy-paste this entire block:**

```bash
# Format as BTRFS
mkfs.btrfs -L nixos /dev/mapper/enc

# Mount temporarily
mount /dev/mapper/enc /mnt

# Create all subvolumes
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/persist
btrfs subvolume create /mnt/log
btrfs subvolume create /mnt/snapshots

# Unmount
umount /mnt
```

**Verify subvolumes created:**

```bash
mount /dev/mapper/enc /mnt
btrfs subvolume list /mnt
umount /mnt
```

Should show 6 subvolumes (ID 256-261).

---

### Step 7: Mount Filesystems with Correct Options

**Copy-paste this entire block:**

```bash
# Mount root subvolume
mount -o subvol=root,compress=zstd,noatime /dev/mapper/enc /mnt

# Create mount points
mkdir -p /mnt/nix
mkdir -p /mnt/home
mkdir -p /mnt/persist
mkdir -p /mnt/var/log
mkdir -p /mnt/snapshots
mkdir -p /mnt/boot

# Mount all subvolumes
mount -o subvol=nix,compress=zstd,noatime /dev/mapper/enc /mnt/nix
mount -o subvol=home,compress=zstd,noatime /dev/mapper/enc /mnt/home
mount -o subvol=persist,compress=zstd,noatime /dev/mapper/enc /mnt/persist
mount -o subvol=log,compress=zstd,noatime /dev/mapper/enc /mnt/var/log
mount -o subvol=snapshots,compress=zstd,noatime /dev/mapper/enc /mnt/snapshots

# Mount boot partition
mount /dev/nvme0n1p1 /mnt/boot
```

**Verify all mounts:**

```bash
mount | grep /mnt
```

Should show 7 mount points: /, /nix, /home, /persist, /var/log, /snapshots, /boot

---

### Step 8: Generate NixOS Configuration

```bash
nixos-generate-config --root /mnt
```

**Verify files created:**

```bash
ls -l /mnt/etc/nixos/
```

Should show `configuration.nix` and `hardware-configuration.nix`

---

### Step 9: Edit Configuration for Minimal GNOME Install

```bash
nano /mnt/etc/nixos/configuration.nix
```

**Replace entire contents with this:**

```nix
{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "energy";
  networking.networkmanager.enable = true;

  # Timezone (change to yours)
  time.timeZone = "America/New_York";

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";

  # GNOME Desktop
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Exclude unwanted GNOME apps
  environment.gnome.excludePackages = with pkgs; [
    gnome-photos
    gnome-tour
    gnome-music
    epiphany
    geary
    totem
  ];

  # Sound
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User account (CHANGE 'yourname' to your actual username!)
  users.users.yourname = {
    isNormalUser = true;
    description = "Your Name";
    extraGroups = [ "wheel" "networkmanager" ];
    packages = with pkgs; [
      firefox
      git
      vim
      gnome-console
    ];
  };

  # Enable sudo
  security.sudo.wheelNeedsPassword = true;

  # System packages
  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    vim
    htop
  ];

  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # DO NOT CHANGE
  system.stateVersion = "24.11";
}
```

**Save and exit:** Press `Ctrl+X`, then `Y`, then `Enter`

---

### Step 10: Verify Hardware Configuration

```bash
cat /mnt/etc/nixos/hardware-configuration.nix
```

**It MUST include:**

1. ✅ `boot.initrd.luks.devices."enc".device` with UUID
2. ✅ All 6 BTRFS subvolumes (root, nix, home, persist, log, snapshots)
3. ✅ `compress=zstd,noatime` options on all BTRFS mounts
4. ✅ `neededForBoot = true;` on persist, log, and snapshots
5. ✅ Boot partition with UUID
6. ✅ Swap device with UUID

**If anything is missing or wrong, regenerate:**

```bash
nixos-generate-config --root /mnt --force
```

Then re-edit `configuration.nix` as in Step 9.

---

### Step 11: Install NixOS

```bash
nixos-install
```

**During installation:**

1. Wait for packages to download and install (5-15 minutes)
2. When prompted, set **root password** (you'll need this once)
3. Installation should complete with "installation finished!"

**If you get errors:**

- Check `/mnt/etc/nixos/hardware-configuration.nix` has all UUIDs
- Verify all filesystems are mounted: `mount | grep /mnt`
- Re-run `nixos-install`

---

### Step 12: Set User Password (Before Reboot)

```bash
nixos-enter --root /mnt -c 'passwd yourname'
```

Replace `yourname` with the username you chose in Step 9.

Enter password twice.

---

### Step 13: Reboot

```bash
# Unmount everything
umount -R /mnt

# Close encrypted partition
cryptsetup close enc

# Turn off swap
swapoff /dev/nvme0n1p2

# Reboot
reboot
```

---

## 🎉 First Boot

### What to Expect:

1. **GRUB menu** appears → select "NixOS"
2. **LUKS passphrase prompt** → enter your encryption passphrase
3. **GDM login screen** → login with your username and password
4. **GNOME Desktop** loads

### If Something Goes Wrong:

**"Wrong passphrase" error:**

- Check keyboard layout (try US layout)
- Check CAPS LOCK is off
- Re-enter passphrase carefully

**Black screen / no GUI:**

- Press `Ctrl+Alt+F2` to get a console
- Login as root
- Check logs: `journalctl -xb`

**"Emergency mode" or boot failure:**

- Boot from USB again
- Run commands from Step 7 to mount filesystems
- Fix `/mnt/etc/nixos/hardware-configuration.nix`
- Re-run `nixos-install`

---

## 📦 Post-Installation (After GNOME is Working)

### Apply Your Full Configuration

Once you're logged into GNOME:

1. **Open Terminal** (press `Super` key, type "Terminal")

2. **Clone your configuration:**

```bash
cd ~
git clone https://github.com/YOUR-USERNAME/nixos-configs.git
cd nixos-configs/nix-config-alexnabokikh
```

3. **Copy hardware config:**

```bash
sudo cp /etc/nixos/hardware-configuration.nix hosts/energy/
```

4. **Verify hardware config matches expected format:**

```bash
cat hosts/energy/hardware-configuration.nix
```

Should match the structure shown at the top of this guide.

5. **Rebuild with your full configuration:**

```bash
sudo nixos-rebuild switch --flake .#energy
```

6. **Reboot to apply changes:**

```bash
reboot
```

7. **After reboot, you'll have:**

- ✅ Niri window manager (instead of GNOME)
- ✅ Full hardware optimizations (Intel CPU/GPU, auto-cpufreq)
- ✅ All security hardening (80+ kernel sysctls, AppArmor, etc.)
- ✅ Network privacy enhancements
- ✅ Development environment ready

---

## 🔍 Verification Commands

After installation, verify everything is working:

```bash
# Check BTRFS subvolumes
btrfs subvolume list /

# Check compression is working
sudo compsize /

# Check LUKS encryption
sudo cryptsetup status enc

# Check mount options
mount | grep btrfs

# Check swap is active
swapon --show

# Check hardware detection
lscpu
lspci | grep VGA
```

---

## 📊 Expected Hardware Config Template

Your `/etc/nixos/hardware-configuration.nix` should look like this:

```nix
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # LUKS encryption
  boot.initrd.luks.devices."enc".device = "/dev/disk/by-uuid/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX";

  # Root subvolume
  fileSystems."/" = {
    device = "/dev/mapper/enc";
    fsType = "btrfs";
    options = [ "subvol=root" "compress=zstd" "noatime" ];
  };

  # Nix store subvolume
  fileSystems."/nix" = {
    device = "/dev/mapper/enc";
    fsType = "btrfs";
    options = [ "subvol=nix" "compress=zstd" "noatime" ];
  };

  # Home directories subvolume
  fileSystems."/home" = {
    device = "/dev/mapper/enc";
    fsType = "btrfs";
    options = [ "subvol=home" "compress=zstd" "noatime" ];
  };

  # Persistent state subvolume (needed early in boot)
  fileSystems."/persist" = {
    device = "/dev/mapper/enc";
    fsType = "btrfs";
    neededForBoot = true;
    options = [ "subvol=persist" "compress=zstd" "noatime" ];
  };

  # System logs subvolume (needed early in boot)
  fileSystems."/var/log" = {
    device = "/dev/mapper/enc";
    fsType = "btrfs";
    neededForBoot = true;
    options = [ "subvol=log" "compress=zstd" "noatime" ];
  };

  # Snapshots subvolume (needed early in boot)
  fileSystems."/snapshots" = {
    device = "/dev/mapper/enc";
    fsType = "btrfs";
    neededForBoot = true;
    options = [ "subvol=snapshots" "compress=zstd" "noatime" ];
  };

  # EFI boot partition
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/XXXX-XXXX";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  # Swap partition
  swapDevices = [
    { device = "/dev/disk/by-uuid/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"; }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
```

---

## 🛠️ Troubleshooting

### Installation Fails with "No Space Left"

```bash
# Check available space
df -h /mnt

# If low, increase NixOS partition size in Step 3
```

### Cannot Mount BTRFS Subvolumes

```bash
# Verify subvolumes exist
mount /dev/mapper/enc /mnt
btrfs subvolume list /mnt
umount /mnt

# Recreate if missing (from Step 6)
```

### LUKS Passphrase Forgotten

**There is NO recovery.** Your data is permanently encrypted.
You must reinstall NixOS from scratch.

### Wrong UUIDs in Hardware Config

```bash
# Find correct UUIDs
blkid

# Edit hardware-configuration.nix
nano /mnt/etc/nixos/hardware-configuration.nix

# Update UUIDs, then re-run
nixos-install
```

---

## ⚡ Quick Command Summary

```bash
# Partitioning
gdisk /dev/nvme0n1

# Formatting
mkfs.vfat -F 32 -n EFI /dev/nvme0n1p1
mkswap -L swap /dev/nvme0n1p2
swapon /dev/nvme0n1p2

# LUKS
cryptsetup luksFormat --type luks2 --cipher aes-xts-plain64 --key-size 512 --hash sha512 --pbkdf argon2id /dev/nvme0n1p6
cryptsetup open /dev/nvme0n1p6 enc

# BTRFS
mkfs.btrfs -L nixos /dev/mapper/enc
mount /dev/mapper/enc /mnt
btrfs subvolume create /mnt/{root,nix,home,persist,log,snapshots}
umount /mnt

# Mount
mount -o subvol=root,compress=zstd,noatime /dev/mapper/enc /mnt
mkdir -p /mnt/{nix,home,persist,var/log,snapshots,boot}
mount -o subvol=nix,compress=zstd,noatime /dev/mapper/enc /mnt/nix
mount -o subvol=home,compress=zstd,noatime /dev/mapper/enc /mnt/home
mount -o subvol=persist,compress=zstd,noatime /dev/mapper/enc /mnt/persist
mount -o subvol=log,compress=zstd,noatime /dev/mapper/enc /mnt/var/log
mount -o subvol=snapshots,compress=zstd,noatime /dev/mapper/enc /mnt/snapshots
mount /dev/nvme0n1p1 /mnt/boot

# Install
nixos-generate-config --root /mnt
nano /mnt/etc/nixos/configuration.nix
nixos-install
nixos-enter --root /mnt -c 'passwd yourname'
reboot
```

---

**Installation complete! 🎉**
