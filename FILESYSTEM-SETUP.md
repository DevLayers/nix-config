# Filesystem Configuration

This document describes the complete filesystem setup for the Energy host, which matches the partitioning scheme created by `partition.sh`.

## Disk Partitioning Scheme

The system uses `/dev/nvme0n1` with the following partition layout:

| Partition | Size    | Type       | Label      | Mount Point      | Description                    |
|-----------|---------|------------|------------|------------------|--------------------------------|
| p1        | 1 GB    | EFI (ef00) | EFI        | /boot            | EFI System Partition           |
| p2        | 8 GB    | Swap (8200)| swap       | [swap]           | Swap partition                 |
| p3        | 102 GB  | NTFS (0700)| Windows-C  | /mnt/windows-c   | Windows C: drive               |
| p4        | 101 GB  | NTFS (0700)| Windows-D  | /mnt/windows-d   | Windows D: drive               |
| p5        | 100 GB  | NTFS (0700)| Windows-E  | /mnt/windows-e   | Windows E: drive               |
| p6        | 199.9 GB| Linux (8300)| NixOS     | [LUKS encrypted] | NixOS system (LUKS + BTRFS)    |

## Encrypted NixOS Partition (p6)

Partition 6 is encrypted with LUKS2 and contains a BTRFS filesystem with multiple subvolumes:

### BTRFS Subvolumes

| Subvolume   | Mount Point | Options                        | neededForBoot |
|-------------|-------------|--------------------------------|---------------|
| root        | /           | compress=zstd, noatime         | No            |
| nix         | /nix        | compress=zstd, noatime         | No            |
| home        | /home       | compress=zstd, noatime         | No            |
| persist     | /persist    | compress=zstd, noatime         | Yes           |
| log         | /var/log    | compress=zstd, noatime         | Yes           |
| snapshots   | /snapshots  | compress=zstd, noatime         | Yes           |

## NTFS Partitions

The three Windows NTFS partitions are configured with the following mount options:

- **File system type**: ntfs-3g (FUSE-based NTFS driver)
- **Permissions**: 
  - uid=1000 (files owned by primary user)
  - gid=100 (files owned by 'users' group)
  - dmask=022 (directories: rwxr-xr-x)
  - fmask=133 (files: rw-r--r--)
- **Access**: Read-Write (rw)

These partitions will automatically mount at boot and be accessible in the file manager.

## Filesystem Support

The system has the following filesystem types enabled in `modules/nixos/fs.nix`:

- vfat (EFI partition)
- ext4 (compatibility)
- btrfs (main system filesystem)
- exfat (external drives)
- ntfs (Windows partitions)

## How It Works in the File Manager

### GTK Bookmarks (Nautilus/GNOME Files)

The system is configured with GTK bookmarks for easy access to all partitions:

**Bookmarks in Sidebar:**
- Documents, Downloads, Pictures, Videos (User directories)
- **Root** - Root filesystem (/)
- **Windows C** - Windows C: drive (/mnt/windows-c)
- **Windows D** - Windows D: drive (/mnt/windows-d)
- **Windows E** - Windows E: drive (/mnt/windows-e)

These bookmarks are configured in `modules/home-manager/misc/gtk/default.nix` and appear in the left sidebar of Nautilus (Files application) for one-click access to any partition.

### Filesystem Visibility

1. **Root filesystem (/)**: Always visible as the main system, now also accessible via "Root" bookmark
2. **Other BTRFS subvolumes**: Mounted as separate directories (/nix, /home, /persist, /var/log, /snapshots)
3. **NTFS partitions**: Appear in file manager via bookmarks:
   - **Windows C** → `/mnt/windows-c` - Windows C: drive
   - **Windows D** → `/mnt/windows-d` - Windows D: drive  
   - **Windows E** → `/mnt/windows-e` - Windows E: drive

The NTFS partitions are now properly configured with:
- ✅ Correct filesystem type (ntfs-3g)
- ✅ Proper permissions for user access
- ✅ Read-write access
- ✅ Automatic mounting at boot
- ✅ Bookmarks in file manager sidebar

## Security Features

- **LUKS2 Encryption**: Full disk encryption on the NixOS partition
  - Cipher: aes-xts-plain64
  - Key size: 512 bits
  - Hash: sha512
  - KDF: argon2id
  
- **BTRFS Features**:
  - Transparent compression (zstd)
  - Snapshots support
  - Subvolume isolation

## Maintenance

- **BTRFS scrub**: Runs weekly on the root filesystem
- **fstrim**: Runs weekly (only on AC power) to optimize SSD performance

## Troubleshooting Bookmarks

If the GTK bookmarks (Root, Windows C/D/E) don't appear in Nautilus sidebar after rebuild:

1. **Rebuild the system**: Run `sudo nixos-rebuild switch` to apply NixOS configuration
2. **Rebuild home-manager**: Run `home-manager switch` to apply user configuration
3. **Restart Nautilus**: Close all Nautilus windows and reopen, or run `nautilus -q` to quit and restart
4. **Check mount points exist**: Run `ls -la /mnt/` to verify windows-c, windows-d, windows-e directories exist
5. **Check mounts are active**: Run `mount | grep windows` to verify partitions are mounted
6. **Check bookmarks file**: Look at `~/.config/gtk-3.0/bookmarks` to verify bookmarks are written correctly

The bookmarks are automatically configured by home-manager and should appear in the left sidebar of Nautilus once the system is rebuilt and Nautilus is restarted.
